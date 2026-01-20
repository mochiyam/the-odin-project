require "csv"

langs = ['en', 'id', 'ko', 'pt', 'vi', 'zh_CHS', 'zh_CHT', 'easy_ja']

langs.each do |lang|
  crew_rows = CSV.read("crew_#{lang}.csv", headers: true)
  beta_rows = CSV.read("beta_#{lang}.csv", headers: true)

  # CSV.foreach("crew.csv", headers: true) do |row|
  #   # row is a CSV::Row object, which can be accessed by header name or index
  #   puts "Japanese: #{row['original_text']}, Translated: #{row['translated_text']}"
  # end
  # 

  def get_clean_text(text)
    return "" if text.nil?
    text.gsub(/<[^>]+>/, '').strip
  end

  crew_lookup =  {}
  crew_rows.each do |row|
    # clean_key = get_clean_text(row['original_text'])
    crew_lookup[row['original_text']] = row
  end

  beta_lookup = {}
  beta_headers = nil
  beta_rows.each do |row|
    beta_headers||= row.headers
    # clean_key = get_clean_text(row['original_text'])
    beta_lookup[row['original_text']] = row
  end

  result_data = []

  beta_lookup.each do |key, beta_lookup_row|
    crew_lookup_row = crew_lookup[key]
    if crew_lookup_row.nil?
      result_data << beta_lookup_row
      next
    end

    # Case 1. If beta and crew has EXACT matches
    if crew_lookup_row['original_text'] == beta_lookup_row['original_text']
      result_data << beta_lookup_row
    # Case 2. If beta has NO tags, but crew DOES (e.g., Beta: "その他", Crew: "<span>その他</span>")
    elsif !beta_lookup_row["original_text"].include?("<") && crew_lookup_row["original_text"].include?("<")
      beta_lookup_row['translated_text'] = get_clean_text(crew_lookup_row['translated_text'])
      result_data << beta_lookup_row

      p beta_lookup_row
    else #if beta_lookup[key] == crew_lookup_row
      crew_translated_text_clean = get_clean_text(crew_lookup_row['translated_text'])
      beta_translated_text_clean = get_clean_text(beta_lookup_row['translated_text'])
      # p crew_translated_text_clean, beta_translated_text_clean
      result_translated_text = beta_lookup_row['translated_text'].gsub(beta_translated_text_clean, crew_translated_text_clean)
      beta_lookup_row['translated_text'] = result_translated_text
      result_data << beta_lookup_row
    end
  end

  # p result_data[7]

  CSV.open("result_translations_#{lang}.csv", 'wb') do |csv|
    csv << beta_headers
    result_data.each { |row| csv << row }
  end


  # beta_word = "<span>Japan</span>"
  # beta_word_clean = 'Japan'
  # crew_word_clean = "Japannnnn"

  # puts beta_word.gsub(beta_word_clean, crew_word_clean,)
  # 
  # user_data = { name: "Alice", age: 30, city: "New York" }
  # p user_data.key?(:name)


end