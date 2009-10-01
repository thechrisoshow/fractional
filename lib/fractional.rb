require 'rational'

module Fractional

  def self.to_f(value)
    if mixed_fraction?(value)
      whole, numerator, denominator = value.scan(/(\d*)\s(\d+)\/(\d+)/).flatten
      (numerator.to_f / denominator.to_f) + whole.to_f
    elsif single_fraction?(value)
      numerator, denominator = value.split("/")
      numerator.to_f / denominator.to_f
    else
      value.to_f
    end
  end

  def self.to_s(value)
    whole_number = value.to_f.truncate.to_i
    
    if whole_number == 0
      float_to_rational(value.to_f).to_s  
    else
      decimal_point_value = get_decimal_point_value(value.to_f)      
      whole_number.to_s + " " + float_to_rational(decimal_point_value).to_s
    end 
  end
  
  def self.round_to_nearest_fraction(value, to_nearest_fraction)
    if value.is_a? String
      to_nearest_float = to_f(to_nearest_fraction)

      to_s((self.to_f(value) / to_nearest_float).round * to_nearest_float)
    else
      to_nearest_float = to_f(to_nearest_fraction)

      (value / to_nearest_float).round * to_nearest_float      
    end
    
  end

  private
    
  def self.fraction?(value)
    value.to_s.count('/') == 1
  end

  def self.single_fraction?(value)
    fraction?(value) and !mixed_fraction?(value)
  end

  def self.mixed_fraction?(value)
    fraction?(value) and value.match(/\d*\s+\d+\/\d+/)
  end
  
  def self.get_decimal_point_value(value)
    value - value.truncate
  end

  # Whoa this method is crazy
  # I nicked it from Jannis Harder at http://markmail.org/message/nqgrsmaixwbrvsno
  def self.float_to_rational(value)
    if value.nan? 
      return Rational(0,0) # Div by zero error 
    elsif value.infinite? 
      return Rational(value<0 ? -1 : 1,0) # Div by zero error 
    end 
    s,e,f = [value].pack("G").unpack("B*").first.unpack("AA11A52") 
    s = (-1)**s.to_i 
    e = e.to_i(2) 
    if e.nonzero? and e<2047
      Rational(s)* Rational(2)**(e-1023)*Rational("1#{f}".to_i(2),0x10000000000000) 
    elsif e.zero? 
      Rational(s)* Rational(2)**(-1024)*Rational("0#{f}".to_i(2),0x10000000000000) 
    end 
  end 
end
