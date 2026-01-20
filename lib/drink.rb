# frozen_string_literal: true

# very basic Drink class
class Drink
  attr_reader :type, :ounces

  def initialize(type = 'water', ounces = 16)
    @type = type
    @ounces = ounces
  end

  def full?
    ounces >= 16
  end

  def test(abc)
    puts abc
    puts "Hello"
  end
end


class Juice < Drink
  def test(abc)
    super()
  end
end



j = Juice.new
j.test("asdf")