module Enumerable
  def my_select
    new_array = []
    if block_given?
      i = 0
      while i < self.size
        new_array << self[i] if yield self[i]
        i += 1
      end
      return new_array
    end
  end
end

class Array
  include Enumerable
end


arr = [1, 2, 3, 4]
test = arr.my_select {|x| x < 2}
p test