module Enumerable
  def my_each
    if block_given?
      i = 0
      while i < self.size do
        yield self[i]
        i += 1
      end
      self
    end
  end
end

# # You will first have to define my_each
# # on the Array class. Methods defined in
# # your enumerable module will have access
# # to this method
class Array
  include Enumerable
  # def initialize(arr)
  #   @arr = arr
  # end
  # def my_each
  #   yield self
  # end
end


# arr = Array.new([1, 2, 3])
# test = arr.my_each do |a|
#   puts a
# end
# puts test
