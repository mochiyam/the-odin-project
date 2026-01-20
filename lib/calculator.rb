class Calculator
  def add(a,b)
    a + b
  end

  def add(*args) # args variable in a list
    total = 0
    args.each {|a| total += a}
    return total
  end
end