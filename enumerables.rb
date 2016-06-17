require 'byebug'

class Array
  def my_each(&proc)
    i = 0
    while i < count
      yield self[i]
      i += 1
    end
    self
  end

  def my_select(&proc)
    acc = []
    self.my_each do |el|
      acc << el if yield el
    end
    acc
  end

  def my_reject(&proc)
    acc = []
    self.my_each do |el|
      acc << el unless yield el
    end
    acc
  end

  def my_any?(&proc)
    self.my_each do |el|
      return true if yield el
    end
    false
  end

  def my_all?(&proc)
    self.my_each do |el|
      return false unless yield el
    end
    true
  end

  def my_flatten
    acc = []
    self.my_each do |el|
      unless el.class == Array
        acc << el
      else
        acc += el.my_flatten
      end
    end
    acc
  end

  def my_zip(*arrs)

    combo_arr = [self] + arrs
    columns = self.size
    rows = combo_arr.size
    transpose = []
    #debugger
    (0...columns).each do |col_i|
      row = []
      (0...rows).each do |row_j|
        row << combo_arr[row_j][col_i]
        # p transpose
      end
      transpose << row
    end
    transpose
  end

  def my_rotate(k = 1)
    k = k % (count)
    self[k..-1] + self[0..k-1]
  end

  def my_join(sep = "")
    str = self.first
    self[1..-1].my_each{ |el| str += sep + el }
    str
  end

  def my_reverse
    arr = []
    self.my_each { |el| arr.unshift(el) }
    arr
  end

  def bubble_sort!
    swapping = !self.empty?
    unsorted_length = self.length
    while swapping
      swapping = false
      (0..unsorted_length - 2).each do |index|
        if swapping = self[index] > self[index + 1]
          self[index], self[index + 1] = self[index + 1], self[index]
        end
      end
      unsorted_length -= 1
    end
    return self
  end

  def bubble_sort
    self.dup.bubble_sort!
  end
end


def factors(num)
  primes = (1..num/2).select { |k| num % k == 0 }
  primes << num
end

def substrings(string)
  subs = []
  string.length.times do |head|
    (head...string.length).each do |tail|
      substr = string[head..tail]
      subs << substr unless subs.include? substr
    end
  end
  subs
end

def subwords(word, dictionary)
  substrings(word).select { |el| dictionary.include? el }
end
