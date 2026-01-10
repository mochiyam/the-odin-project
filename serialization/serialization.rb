require 'yaml'
YAML.load File.read('test.yaml')


def from_yaml(string)
  data = YAML.load string
  p data
end

from_yaml(YAML.dump File.read('test.yaml'))


#!/usr/bin/ruby

$stdout.print "Ruby language\n"
$stdout.puts "Python language"

f = File.open('output.txt', 'w')
f.puts "The Ruby tutorial"
f.close