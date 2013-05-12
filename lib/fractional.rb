require 'rational'

class Fractional
  SINGLE_FRACTION = /^\s*(\-?\d+)\/(\-?\d+)\s*$/
  MIXED_FRACTION = /^\s*(\-?\d*)\s+(\d+)\/(\d+)\s*$/

  def initialize( value )

  end

  def to_s( options = {} ) #mixed_fraction: true

  end

  def to_f

  end

  def to_r

  end

  def to_i

  end

  def ==

  end

  [:+, :-, :*, :/, :**].each do |math_operator|
    define_method(math_operator) do |another_fractional|
      Fractional.new(self.to_r.send(math_operator, another_fractional))
    end
  end

  def self.float_to_fractional

  end

  def self.string_to_fractional

  end

  def self.string_is_fraction?

  end

  def self.string_is_mixed_fraction?

  end

  def self.string_is_single_fraction?

  end


























  #def initialize(value)
    #value.to_r
    #@value = Rational(value)
  #end

  #def to_s
    #@value
  #end

  #def to_f
    #Fractional.to_f(@value)
  #end

  #[:+, :-, :*, :/].each do |math_operator|
    #define_method(math_operator) do |another_fractional|
      #Fractional.new(Fractional.to_s(self.to_f.send(math_operator, another_fractional.to_f)))
    #end
  #end

  #def self.to_f(value)
    #result = 0

    #if mixed_fraction?(value)
      #whole, numerator, denominator = value.scan(MIXED_FRACTION).flatten

      #result = (numerator.to_f / denominator.to_f) + whole.to_f.abs

      #result = whole.to_f > 0 ? result : -result
    #elsif single_fraction?(value)
      #numerator, denominator = value.split("/")
      #result =  numerator.to_f / denominator.to_f
    #else
      #result = value.to_f
    #end

    #result
  #end

  #def self.to_s(value, args={})
    ## TODO add repeat option
    #whole_number = value.to_f.truncate.to_i

    #if whole_number == 0 # Single fraction
      #fractional_part_to_string(value, args[:to_nearest])
    #else # Mixed fraction
      #decimal_point_value = get_decimal_point_value(value.to_f)
      #return whole_number.to_s if decimal_point_value == 0

      #fractional_part = fractional_part_to_string(decimal_point_value.abs, args[:to_nearest])

      #if (Rational(fractional_part) == 1.0) || (Rational(fractional_part) == 0)
        #(whole_number + fractional_part.to_i).to_s
      #else
        #whole_number.to_s + " " + fractional_part
      #end
    #end
  #end

  #def self.round_to_nearest_fraction(value, to_nearest_fraction)
    #if value.is_a? String
      #to_nearest_float = to_f(to_nearest_fraction)

      #to_s((self.to_f(value) / to_nearest_float).round * to_nearest_float)
    #else
      #to_nearest_float = to_f(to_nearest_fraction)

      #(value / to_nearest_float).round * to_nearest_float
    #end

  #end

  #private

  #def self.fraction?(value)
    #value.is_a? String and (value.match(SINGLE_FRACTION) or value.match(MIXED_FRACTION))
  #end

  #def self.single_fraction?(value)
    #fraction?(value) and value.match(SINGLE_FRACTION)
  #end

  #def self.mixed_fraction?(value)
    #fraction?(value) and value.match(MIXED_FRACTION)
  #end

  #def self.get_decimal_point_value(value)
    #value - value.truncate
  #end

  #def self.fractional_part_to_string(value, round)
    #if round
      #round_to_nearest_fraction(float_to_rational(value.to_f).to_s, round)
    #else
      #float_to_rational(value.to_f).to_s
    #end
  #end

  #def self.float_to_rational(value)
    #if value.to_f.nan?
      #return Rational(0,0) # Div by zero error
    #elsif value.to_f.infinite?
      #return Rational(value<0 ? -1 : 1,0) # Div by zero error
    #end

    ## first try to convert a repeating decimal
    #repeat = float_to_rational_repeat(value)
    #return repeat unless repeat.nil?

    ## finally assume a simple decimal 
    #return Rational(value)
  #end

  #def self.float_to_rational_repeat(base_value)
    #normalized_value = base_value.to_f
    #repeat = find_repeat( normalized_value )

    #if repeat.nil? or repeat.length < 1
      ## try again chomping off the last number (fixes float rounding issues)
      #normalized_value = normalized_value.to_s[0...-1].to_f
      #repeat = find_repeat(normalized_value.to_s)
    #end
    
    #if !repeat or repeat.length < 1
      #return nil
    #else
      #return fractional_from_parts(
        #find_before_decimal(normalized_value), 
        #find_after_decimal(normalized_value),
        #repeat)
    #end
  #end

  #def self.find_after_decimal( decimal )
    #s_decimal = decimal.to_s
    #regex = /(#{find_repeat(s_decimal)})+/
    #last = s_decimal.index( regex )
    #first = s_decimal.index( '.' ) + 1
    #s_decimal[first...last]
  #end

  #def self.find_before_decimal( decimal )
    #numeric = decimal.to_f.floor.to_i
    #if numeric == 0
      #""
    #else
      #numeric.to_s
    #end
  #end

  #def self.find_repeat( decimal )
    #return largest_repeat( decimal.to_s.reverse, 0 ).reverse
  #end

  #def self.largest_repeat( string, i )
    #if i * 2 > string.length
      #return ""
    #end
    #repeat_string = string[0..i]
    #next_best = largest_repeat( string, i + 1)
    #if repeat_string == string[i+1..2*i + 1]
      #repeat_string.length > next_best.length ? repeat_string : next_best
    #else
      #next_best
    #end
  #end

  #def self.fractional_from_parts(before_decimal, after_decimal, repeat)
    #numerator = "#{before_decimal}#{after_decimal}#{repeat}".to_i - "#{before_decimal}#{after_decimal}".to_i
    #denominator = 10 ** (after_decimal.length + repeat.length) - 10 ** after_decimal.length
    #return Rational( numerator, denominator )
  #end
end
