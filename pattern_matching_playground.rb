### Variable Pattern
# a = 5
# case 1
# in a   # This says: "Whatever is in the case (1), put it into a new variable called 'a'"
#   a
# end

# puts a # a is now 1 because the pattern match overwrote it.

# =======================================================================================

# To fix this... 
# a = 5
# case 1
# in ^a  # This says: "Is the value in the case (1) equal to my pinned value (5)?"
#   puts "It matched!"
# else
#   puts "No match!"
# end

# puts a # a is still 5!

# =======================================================================================
# 
# 
# login = { username: 'hornby', password: 'iliketrains' }
# login => { username: username }
# puts "Logged in with username #{username}"

# login1 = {password: "abc"}
# login1 => { username: username } #NoMatchingPatternKeyError
# login1[:username] # => nil


# =======================================================================================
# 
# arr = [1, 2]
# case arr
# in [Integer, Integer]
#   puts :match
# in [String, String]
#   puts :no_match
# end

# puts "here here"

# case arr
# when [Integer, Integer]
#   puts :match
# when [String, String]
#   puts :no_match
# end

# =======================================================================================
#  Integer === 1 # true
# [Integer, Integer] === [1, 2] #false
# #^ It treats array like a single object. It does not iterate through the array
# 
# =======================================================================================
# 
# Hash pattern matching
# case { a: 'ant', b: 'ball' }
# in { a: 'ant', **nil }
#   puts :no_match
# in { a: 'ant', b: 'ball' }
#   puts :match
# end
# user_data = { name: "Moana", role: "admin", id: 42 }

# case user_data
# in { role: "admin" } => admin_user
#   # This block only runs if role is admin.
#   # 'admin_user' now holds the whole hash.
#   puts "Access granted to #{admin_user[:name]}"
# else
#   puts "Access denied."
# end

# =======================================================================================

login = { username: 'hornby', password: 'iliketrains' }
# 1. Searching: It looks into the login hash for the key :username.
# 2. Validating: It ensures that key exists (it will crash if it doesn't).
# 3. Assigning: It takes the value found there and creates a new local variable in your current scope named username.
# 
#Syntax:  key_in_hash: variable_name_you_want
login => { username: username1 }
puts "Logged in with username #{username1}"

# ...is roughly equivalent to this:
# if login.has_key?(:username)
#   username = login[:username]
# else
#   raise NoMatchingPatternError
# end
# 
#

#
# =======================================================================================
# PATTERN MATCHING
data = [
  {name: 'James', age: 50, first_language: 'english', job_title: 'general manager'},
  {name: 'Jill', age: 32, first_language: 'nil', job_title: 'leet coder'},
  {name: 'Helen', age: 24, first_language: 'dutch', job_title: 'biscuit quality control'},
  {name: 'Bob', age: 64, first_language: 'english', job_title: 'table tennis king'},
  {name: 'Betty', age: 55, first_language: 'spanish', job_title: 'pie maker'},
]

# === BEFORE PATTERN MATCHING === 
name = 'Jill'
age = 32
job_title = 'leet coder'

# match = data.find do |person|
#   person[:name] == name && person[:age] == age && person[:job_title] == job_title # so longg...
# end

# match&.fetch(:first_language) # need to use & for null safety

# === AFTER PATTERN MATCHING === 
# name = 'Jill'
# age = 32
# job_title = 'leet coder'

# first_language = case data
# in [*, {name: ^name, age: ^age, job_title: ^job_title, first_language: fl}, *]
#   if first_language
#     puts "JERE" # If the first_language is nil
#     fl
#   else
#     puts "first langauge is nil"
#   end
# else # If the first_langauge is missing in the data!!
#   "NADA"
# end
# puts first_language

# case data
# in [*, {name:^name, age:^age, first_language: first_language, job_title:^job_title}, *] if first_language
#   p "asdfawef"
# else 
#   first_langauge = nil
# end

# case data
# in [*, {name:^name, age:^age, job_title:^job_title} => match, *] 
#   first_language = match[:first_langauge]
# else 
#   first_langauge = nil
# end

# puts first_language

# food = { a: 'apple', b: 'banana', c: 'carrot'}
# a = 'apple'
# c = 'carrot'
# case food
# in {a:^a, c:^c} => match
#   p match
# end

# #=======================================================================================

# YIELD
# # Older way...
# def logger(data, mode)
#   if mode == :puts
#     puts data
#   elsif mode == :p
#     p data
#   elsif mode == :uppercase
#     puts data.upcase
#   end
#   # What if they want to save it to a file? Or wrap it in stars? 
#   # You have to keep adding 'if' statements forever!
# end

# # Yield way: it's like injecting your own logic into the method
# def logger(data)
#   puts "--- LOG START ---"
#   yield(data) # This is the "Fill-in-the-blank" spot
#   puts "--- LOG END ---"
# end

# # User A wants a simple puts:
# logger("Hello") { |info| puts info }

# # User B wants to inspect the object:
# logger("Hello") { |info| p info }

# # User C wants to do something you NEVER even thought of:
# logger("Hello") { |info| puts "⭐️ #{info.upcase} ⭐️" }
# 


# #What if there is multiple different banks and you want to handle it with only one method for transaction?
# @transactions = [1000, -400, 12000, -5000]

# def transaction_statement
#   @transactions.each do |transaction|
#     yield transaction # you can do `p yield transaction` here to have more control of how you want to output
#   end
# end

# # Bank side
# transaction_statement do |transaction|
#   p "%0.2f" % transaction # Does it's own calculation here
# end


# def test_yield
#   hash = {a: 'apple', b: 'banana', c: 'cookie', d: nil}

#   hash.each do |key, value|
#     yield key, value
#   end
# end

# test_yield { |key, value| puts "#{key}: #{value}" }
# #=======================================================================================
# 
# #BLOCK CONTROL
# def test_yield
#   if block_given?
#     yield.count
#   else
#     "nope"
#   end
# end

# test_yield

# #=======================================================================================
# #LAMBDA
# #A lambda is a way to write a block and save it to a variable. 

# #Stabby stabby lambda
# my_lambda = -> { puts "Stabby stabby" }

## Option 1: Accept argument with stabby stabby
# my_lambda = -> (name) { puts "my name is #{name}" } 
# my_lambda.call("Moana")
## Option 2: No stabby
# my_age = lambda { |age| puts "my age is #{age}" }
# my_age.call(31)


# #=======================================================================================
# #PROC
# #proc is just an object that you can use to store blocks and pass them around like variables
# a_proc = Proc.new { |name| puts "My name is #{name}" }
# a_proc.call("Moana")
# a_proc = proc { |name| puts "My name is #{name}" } # also same same
# 
# # What is the difference between PROC and LAMBDA you say???
# 
# # 1. Arguments
# a_proc_arg = Proc.new { |name| puts "My name is #{name}" }
# a_proc_arg.call() # Will just be nil for name

# a_lamda_arg = -> (name) { puts "My name is #{name}" }
# a_lamda_arg.call() # ARGUMENT ERROR

# nested_array = [[1, 2], [3, 4], [5, 6]]
# nested_array.select {|a, b| a + b > 10 } # map, each, select is treated as NON-LAMBDA proc

# p = proc {|x, y| x }
# l = lambda {|x, y| x }
# puts [[1, 2], [3, 4]].map(&p) #=> [1, 3]
# # puts [[1, 2], [3, 4]].map(&l) # ArgumentError: wrong number of arguments (given 1, expected 2)

# # Sooooo LAMDA is much stricter!

# # 2. Return
# def my_method
#   # a_proc = Proc.new { return }
#   # puts "this line will be printed"
#   # a_proc.call # I'm done with this WHOLE method my_method
#   # puts "this line is never reached"

#   a_lambda = -> {return}
#   puts "this line will be printed"
#   a_lambda.call # I'm done with this lamda!
#   puts "EH? this line will ALSO reach?!"
# end

# my_method

# # Proc exists because
# # def find_something(arr)
# #   arr.each do |item| # each is a NON-LAMDA proc
# #     return item if item == "Target" # This exits find_something, not just the block!
# #   end
# # end
# # 

# arr = ["1", "2", "3"]
# arr.map(&:to_i)
# # 
# # 1. .map is a method that expect a block, &:to_i
# #    :to_i is just a label for a method (Every time it's used, it points to the exact same memory)
# # 2. Calls #to_proc ('&' is used)
# # 3. $:to_i creates a Proc "When you receive an object, let's call :to_i and RUN IT!!"
# # 4. Proc looks takes "1" and checks...
# # 5. Symbol Table: finds :to_i and retrieves the memory address (The "Who dis?")
# # 6. Object's Class: (String) Looks into the Method Table 
# # 7. String Table: Looks for :to_i and finds the memory address (The "How?")
# # 8. CPU: Jumps to the pointed address and converts string to an integer.
# sym = :to_i
# puts "Symbol Table 'Address' (Hex): 0x#{sym.object_id.to_s(16)}"
# puts "Symbol table: #{sym.object_id}"

# method_obj = "1".method(:to_i)
# puts method_obj.inspect # .inspect shows the internal memory address of what method's location

# Symbol.all_symbols # Symbol Table
# String.instance_methods.sort #String Table

# # 1. The address of the Symbol (The Name)
# symbol_address = :to_i.object_id
# puts "Symbol Object ID: #{symbol_address}"

# # 2. The address of the Method (The Action)
# # We use .method to get the 'pointer' to the actual code
# method_location = "1".method(:to_i)
# puts "Method Object: #{method_location.inspect}"


# def amp_method
#   yield
# end

# my_proc = Proc.new { puts "proc partyyy" }

# amp_method(&my_proc) #append '&' to a Proc object to create a block


a = [1, 2, 3, 4]
a.find { |n| n == 2 }

def find_moana(arr)
  arr.each do |a|
    yield a
  end 
end

find_moana(a) { |n| puts n if n == 2 }

# # Use Enumerables
module Enumerable
  def my_find
    self.each do |elem|
      return elem if yield(elem)
    end

    nil
  end
end

a = [1, 2, 3]
a.my_find { |n| n == 2 }
#=> 2

# #=======================================================================================
# # Randommmm~
#
val1 = true and false # (val1 = true) and false
val2 = true && false  # val2 = (true && false)
# puts val1, val2

# In Ruby, only values that evaluate to FALSE is, false and nil
p true    ? "true" : "false"
p false   ? "true" : "false"
p nil     ? "true" : "false"
p 1       ? "true" : "false"
p 0       ? "true" : "false"
p "false" ? "true" : "false"
p ""      ? "true" : "false"
p []      ? "true" : "false"

test = { abc: 'hello', 'another_key' => 123, 4567 => 'third' }
p test.keys.map(&:to_s).sort_by(&:length)