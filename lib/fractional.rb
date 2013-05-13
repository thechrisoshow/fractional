require 'rational'
require 'deprecated'

class Fractional < Numeric
  extend DeprecatedFractionalMethods

  SINGLE_FRACTION = /^\s*(\-?\d+)\/(\-?\d+)\s*$/
  MIXED_FRACTION = /^\s*(\-?\d*)\s+(\d+)\/(\d+)\s*$/

  def initialize( value, options={} )
    case value
    when Rational
      @value = value
    when String
      @value = Fractional.string_to_fraction( value, options )
    when Fixnum
      @value = Rational(value)
    when Numeric
      @value = Fractional.float_to_fraction( value.to_f, options )
    else
      raise TypeError, "Cannot instantiate Fractional from #{value.class}"
    end

  end

  def method_missing(name, *args, &blk)
    return_value = @value.send(name, *args, &blk)
    return_value.is_a?(Rational) ? Fractional.new(return_value) : return_value
  end

  def to_s( options={} )
    if options[:mixed_fraction] or options[:mixed_number]
      to_join = []
      if whole_part != 0
        to_join << whole_part.to_s
      end
      if fractional_part != 0
        to_join << fractional_part.abs.to_s
      end
      to_join.join(" ")
    else
      @value.to_s
    end
  end

  def to_f
    @value.to_f
  end

  def to_r
    @value
  end

  def to_i
    whole_part
  end

  def whole_part
    @value.truncate
  end

  def fractional_part
    @value - whole_part
  end

  def ==( other_num )
    @value == other_num
  end

  def <=>(other)
    case other
    when Fractional, Rational
      self.to_r <=> other.to_r
    when Numeric
      @value <=> other
    when String
      @value <=> Fractional.new(other).to_r
    else
      nil
    end
  end

  def coerce(other)
    case other
    when Numeric
      return Fractional.new(other), self
    when String
      return Fractional.new(other), self
    else
      raise TypeError, "#{other.class} cannot be coerced into #{Numeric}"
    end
  end


  [:+, :-, :*, :/, :**].each do |math_operator|
    define_method(math_operator) do |another_fractional|
      if another_fractional.is_a? Fractional or another_fractional.is_a? Rational
        Fractional.new(@value.send(math_operator, another_fractional.to_r))
      elsif another_fractional.is_a? Numeric
        self.send(math_operator, Fractional.new(another_fractional))
      else
        Fractional.new(self.to_r.send(math_operator, another_fractional))
      end
    end
  end

  def self.float_to_fraction( value, options={} )
    if value.to_f.nan?
      return Rational(0,0) # Div by zero error
    elsif value.to_f.infinite?
      return Rational(value<0 ? -1 : 1,0) # Div by zero error
    end

    if options[:to_nearest]
      return self.round_to_nearest_fraction( value, options[:to_nearest] )
    end

    # first try to convert a repeating decimal unless guesstimate is forbidden
    unless options[:exact]
      repeat = float_to_rational_repeat(value)
      return repeat unless repeat.nil?
    end

    # finally assume a simple decimal
    # The to_s helps with float rounding issues
    return Rational(value.to_s)

  end

  def self.string_to_fraction( value, options={} )
    if string_is_mixed_fraction?(value)
      whole, numerator, denominator = value.scan(MIXED_FRACTION).flatten
      return Rational( (whole.to_i.abs * denominator.to_i + numerator.to_i) *
                      whole.to_i / whole.to_i.abs, denominator.to_i )
    elsif string_is_single_fraction?(value)
      numerator, denominator = value.split("/")
      return Rational(numerator.to_i, denominator.to_i)
    else
      return float_to_fraction(value.to_f, options)
    end
  end

  def self.string_is_fraction?( value )
    value.is_a? String and (value.match(SINGLE_FRACTION) or value.match(MIXED_FRACTION))
  end

  def self.string_is_mixed_fraction?( value )
    string_is_fraction?(value) and value.match(MIXED_FRACTION)
  end

  def self.string_is_single_fraction?( value )
    string_is_fraction?(value) and value.match(SINGLE_FRACTION)
  end

  def self.float_to_rational_repeat(base_value)
    normalized_value = base_value.to_f
    repeat = find_repeat( normalized_value )

    if repeat.nil? or repeat.length < 1
      # try again chomping off the last number (fixes float rounding issues)
      normalized_value = normalized_value.to_s[0...-1].to_f
      repeat = find_repeat(normalized_value.to_s)
    end

    if !repeat or repeat.length < 1
      return nil
    else
      return fractional_from_parts(
        find_before_decimal(normalized_value),
        find_after_decimal(normalized_value),
        repeat)
    end
  end

  def self.find_after_decimal( decimal )
    s_decimal = decimal.to_s
    regex = /(#{find_repeat(s_decimal)})+/
    last = s_decimal.index( regex )
    first = s_decimal.index( '.' ) + 1
    s_decimal[first...last]
  end

  def self.find_before_decimal( decimal )
    numeric = decimal.to_f.truncate.to_i
    if numeric == 0
      decimal.to_f < 0 ? "-0" : "0"
    else
      numeric.to_s
    end
  end

  def self.find_repeat( decimal )
    return largest_repeat( decimal.to_s.reverse, 0 ).reverse
  end

  def self.largest_repeat( string, i )
    if i * 2 > string.length
      return ""
    end
    repeat_string = string[0..i]
    next_best = largest_repeat( string, i + 1)
    if repeat_string == string[i+1..2*i + 1]
      repeat_string.length > next_best.length ? repeat_string : next_best
    else
      next_best
    end
  end

  def self.fractional_from_parts(before_decimal, after_decimal, repeat)
    numerator = "#{before_decimal}#{after_decimal}#{repeat}".to_i - "#{before_decimal}#{after_decimal}".to_i
    denominator = 10 ** (after_decimal.length + repeat.length) - 10 ** after_decimal.length
    return Rational( numerator, denominator )
  end

  def self.round_to_nearest_fraction(value, to_nearest_fraction)
    to_nearest_float = Fractional.new(to_nearest_fraction).to_f
    Fractional.new((Fractional.new(value).to_f / to_nearest_float).round * to_nearest_float)
  end

end
