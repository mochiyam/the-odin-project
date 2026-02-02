require 'yaml'

# Deep merge helper
def deep_merge(target, source)
  source.each do |key, value|
    if value.is_a?(Hash) && target[key].is_a?(Hash)
      deep_merge(target[key], value)
    else
      target[key] = value
    end
  end
  target
end

# Get modified files
modified_files = [
  'app/views/errors/error_403.html.haml',
  'app/views/layouts/_navigation.html.haml',
  'app/views/shared/_mobile_app_banner.html.haml',
  'app/views/users/_menu.html.haml',
  'packs/auth_app/app/views/devise/registrations/_message_agreement_for_using_user_information_modal.html.haml',
  'packs/auth_app/app/views/devise/registrations/change_password.html.haml',
  'packs/auth_app/app/views/devise/registrations/edit.html.haml',
  'packs/auth_app/app/views/devise/sessions/login_two_factor.html.haml'
]

# Load locale files
locales = {}
Dir.glob('config/locales/**/*.ja.yml').each do |file|
  begin
    content = YAML.load_file(file, aliases: true)
    deep_merge(locales, content) if content.is_a?(Hash)
  rescue => e
    # Suppress warnings for alias parsing
  end
end
Dir.glob('packs/**/config/locales/**/*.ja.yml').each do |file|
  begin
    content = YAML.load_file(file, aliases: true)
    deep_merge(locales, content) if content.is_a?(Hash)
  rescue => e
    # Suppress warnings for alias parsing
  end
end
# Also load .yml files inside ja/ directories in packs
Dir.glob('packs/**/config/locales/ja/**/*.yml').each do |file|
  begin
    content = YAML.load_file(file, aliases: true)
    deep_merge(locales, content) if content.is_a?(Hash)
  rescue => e
    # Suppress warnings for alias parsing
  end
end

# Extract arguments from t() call arguments string
def extract_t_call_args(args_str)
  return {} unless args_str
  
  args = {}
  # Match key: value patterns
  # Pattern: arg_name: "value" or arg_name: 'value' or arg_name: variable_name
  # This regex handles quoted strings and variable names (including those with dots)
  # The pattern [^\s,)]+ matches non-whitespace, non-comma, non-paren characters
  # For variable names like resource.unconfirmed_email, we need to allow dots
  args_str.scan(/(\w+):\s*(['"](?:[^'"]*)['"]|[^\s,)]+(?:\.[^\s,)]+)*)/m) do |key, value|
    # Remove any leading/trailing whitespace including newlines
    clean_value = value.strip.gsub(/[\r\n]+/, ' ').strip
    args[key.to_sym] = clean_value
  end
  args
end

# Extract argument names used in locale string (%{arg_name} pattern)
def extract_locale_args(locale_str)
  return [] unless locale_str.is_a?(String)
  locale_str.scan(/%\{(\w+)\}/).flatten.map(&:to_sym)
end

# Extract t() calls with defaults and check arguments
errors = []
modified_files.each do |file_path|
  p File.exist?(file_path)
  next unless File.exist?(file_path)
  content = File.read(file_path, encoding: 'UTF-8')
  
  # Find all t( calls using regex to capture key and arguments
  # Pattern: t('key' or t("key" followed by optional arguments
  content.scan(/t\((['"])([^'"]+)\1\s*,?\s*(.*?)\)/m) do |quote_char, key, args_str|
    # Skip if this doesn't look like a valid t() call (e.g., if args_str is empty and there's no default)
    # But we'll process it anyway to check for defaults and arguments
    
    keys = key.split('.')
    locale_value = locales.dig('ja', *keys) || locales.dig(*keys)
    
    # Check if key exists and extract default
    if args_str.include?('default:')
      # Match default: "value" or default: 'value' - handle both quote types
      default_match = args_str.match(/default:\s*['"]([^'"]+)['"]/)
      puts default_match
      if default_match
        default = default_match[1]
        if locale_value.nil?
          errors << "#{file_path}: Key '#{key}' not found in locale files"
        elsif locale_value != default
          errors << "#{file_path}: Key '#{key}' - Default '#{default}' doesn't match locale '#{locale_value}'"
        end
      end
    end
    
    # Check arguments (except default)
    if locale_value.is_a?(String)
      locale_args = extract_locale_args(locale_value)
      passed_args = extract_t_call_args(args_str)
      passed_args.delete(:default) # Exclude default from check
      
      passed_args.each do |arg_name, _arg_value|
        unless locale_args.include?(arg_name)
          errors << "#{file_path}: Key '#{key}' - Argument '#{arg_name}' is passed but not used in locale string"
        end
      end
    end
  end
  
  # Also handle cases where there are no arguments (just t('key'))
  content.scan(/t\((['"])([^'"]+)\1\s*\)/) do |quote_char, key|
    keys = key.split('.')
    locale_value = locales.dig('ja', *keys) || locales.dig(*keys)
    if locale_value.nil?
      errors << "#{file_path}: Key '#{key}' not found in locale files"
    end
  end
  
  next # Skip the old while loop logic
    
end

if errors.empty?
  puts '✓ All defaults match the locale dictionaries and all arguments are used!'
  exit 0
else
  puts "✗ Found #{errors.size} issue(s):"
  errors.each { |e| puts "  #{e}" }
  exit 1
end