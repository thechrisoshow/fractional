require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

##################################
# CLASS METHODS                  #
##################################
describe "Fractional::new" do
  it "should accept Rationals" do
    Fractional.new(Rational(3,4)).should_not be_nil
  end

  it "should accept strings" do
    Fractional.new("3/4").should_not be_nil
  end

  it "should accept floats" do
    Fractional.new(0.75).should_not be_nil
  end

  it "should pass options down (such as exact)" do
    Fractional.new(0.333, exact: true).should_not == Rational(1,3)
    Fractional.new("0.333", exact: true).should_not == Rational(1,3)
  end

end

describe "Fractional::float_to_fractional" do
  it "should parse simple decimals" do
    Fractional.float_to_fraction(0.5).should == Fractional.new(Rational(1,2))
    Fractional.float_to_fraction(1.5).should == Fractional.new(Rational(3,2))
    Fractional.float_to_fraction(1100).should == Fractional.new(Rational(1100,1))
    # This next example is especially important as Rational(1.2) is not a nice
    # number.
    Fractional.float_to_fraction(1.2).should == Fractional.new(Rational(6,5))
  end

  it "should parse more complex decimals" do
    Fractional.float_to_fraction(1100.875).should == Fractional.new(Rational(8807,8))
  end

  it "should allow for negative values for mixed fractions" do
    Fractional.float_to_fraction(-1100.875).should == Fractional.new(Rational(-8807,8))
  end

  it "should allow for negative values for single fractions" do
    Fractional.float_to_fraction(-0.875).should == Fractional.new(Rational(-7,8))
  end

  it "should allow for negative mixed fractions that that are rounded" do
    Fractional.float_to_fraction(-101.140625, :to_nearest => "1/64").should == Fractional.new("-101 9/64")
  end

  it "should allow for negative single fractions that that are rounded" do
    Fractional.float_to_fraction(-0.140625, :to_nearest => "1/64").should == Fractional.new("-9/64")
  end

  it "should round if passed 'to nearest'" do
    Fractional.float_to_fraction(1100.14285714286, :to_nearest => "1/64").should == Fractional.new("1100 9/64")
  end

  it "should round if passed 'to_nearest' that is a float" do
    Fractional.float_to_fraction(1100.14285714286, :to_nearest => 0.015625).should == Fractional.new("1100 9/64")
  end

  it "should round if passed 'to_nearest' and is a simple fraction" do
    Fractional.float_to_fraction(0.14285714286, :to_nearest => "1/64").should == Fractional.new("9/64")
  end

  it "should round if passed 'to_nearest' that rounds to nearest whole number" do
    Fractional.float_to_fraction(1100.875, :to_nearest => "1/2").should == Fractional.new("1101")
    Fractional.float_to_fraction(1100.2, :to_nearest => "1/2").should == Fractional.new("1100")
  end

end

describe "Fractional::string_to_fractional" do
  it "should parse a single fraction" do
    Fractional.string_to_fraction('1/2').should == Fractional.new(Rational(1,2))
  end

  it "should parse a mixed fraction" do
    Fractional.string_to_fraction('1 2/4').should == Fractional.new(Rational(3,2))
    Fractional.string_to_fraction("1100 7/8").should == Fractional.new(Rational(8807,8))
  end

  it "should parse a simple decimal" do
    Fractional.string_to_fraction('1.5').should == Fractional.new(Rational(3,2))
  end

  it "should allow for negative mixed fractions" do
    Fractional.string_to_fraction('-10 1/2').should == Fractional.new(Rational(-21,2))
  end

  it "should allow for negative single fractions" do
    Fractional.string_to_fraction("-1/64").should == Fractional.new(Rational(-1,64))
  end

  it "should allow for negative denominators in single fractions" do
    Fractional.string_to_fraction("1/-64").should == Fractional.new(Rational(-1,64))
    Fractional.string_to_fraction("-1/-64").should == Fractional.new(Rational(1,64))
  end

  it "should ignore repeated whitespace" do
    Fractional.string_to_fraction("6   5/8").should == Fractional.string_to_fraction("6 5/8")
  end

  it "should try to get an accurate estimation of floating point values by default" do
    Fractional.string_to_fraction("0.3333").should == Fractional.float_to_fraction(0.33333)
  end

  it "should not estimate if exact is specified" do
    Fractional.string_to_fraction("0.3333", exact: true).should_not == Rational(1,3)
  end

end

describe "Fractional::string_is_fraction?" do
  it "should recognize a simple fraction" do
    Fractional.string_is_fraction?("3/4").should be_true
  end

  it "should recognize a mixed fraction" do
    Fractional.string_is_fraction?("1 11/12").should be_true
  end

  it "should recognize a negative fraction" do
    Fractional.string_is_fraction?("-3/4").should be_true
  end

  it "should recognize a negative mixed fraction" do
    Fractional.string_is_fraction?("-6 2/9").should be_true
  end

  it "should accept more than one space between the whole number and fractional part" do
    Fractional.string_is_fraction?("1  2/3").should be_true
    Fractional.string_is_fraction?("3               1/2").should be_true
  end

  it "should accept fractions with front and rear padding" do
    Fractional.string_is_fraction?("     2/3").should be_true
    Fractional.string_is_fraction?("2/3      ").should be_true
    Fractional.string_is_fraction?("      2/3     ").should be_true
    Fractional.string_is_fraction?("   1 2/3").should be_true
    Fractional.string_is_fraction?("1 2/3      ").should be_true
    Fractional.string_is_fraction?("    1 2/3   ").should be_true
  end

  it "should not recognize decimals" do
    Fractional.string_is_fraction?("2.3").should be_false
  end

  it "should not recognize two consecutive fractions" do
    Fractional.string_is_fraction?("2/3 9/5").should be_false
  end

  it "should not recognize a string with a slash" do
    Fractional.string_is_fraction?("n/a").should be_false
  end

  it "should not recognize a fraction mixed with non-decimals" do
    Fractional.string_is_fraction?("3a/4").should be_false
    Fractional.string_is_fraction?("a2/3").should be_false
    Fractional.string_is_fraction?("1 2/3a").should be_false
  end

  it "should not recognize fractions with improper spacing" do
    Fractional.string_is_fraction?("2 /2").should be_false
    Fractional.string_is_fraction?("1/ 3").should be_false
    Fractional.string_is_fraction?("1  2/  3").should be_false
    Fractional.string_is_fraction?("1 2    /3").should be_false
  end

end

describe "Fractional::string_is_mixed_fraction?" do
  it "should recognize a mixed fraction" do
    Fractional.string_is_mixed_fraction?("1 11/12").should be_true
  end

  it "should recognize a negative mixed fraciton" do
    Fractional.string_is_mixed_fraction?("-1 11/12").should be_true
  end

  it "should not recognize a single fraction" do
    Fractional.string_is_mixed_fraction?("3/4").should be_false
  end

end

describe "Fractional::string_is_single_fraction?" do
  it "should recognize a single fraction" do
    Fractional.string_is_single_fraction?("3/4").should be_true
  end

  it "should recognize a negative numerator with a single fraction" do
    Fractional.string_is_single_fraction?("-3/4").should be_true
  end

  it "should not recognize a mixed fraction" do
    Fractional.string_is_single_fraction?("1 11/12").should be_false
  end

  it "should allow for negative denominators in single fractions" do
    Fractional.string_is_single_fraction?("1/-64").should be_true
    Fractional.string_is_single_fraction?("-1/-64").should be_true
  end

end

describe "Frational", "fractional_from_parts" do
  it "should return rational values for various decimals" do
    Fractional.fractional_from_parts("","","3").should eq(Rational(1,3))
    Fractional.fractional_from_parts("","","7").should eq(Rational(7,9))
    Fractional.fractional_from_parts("","","9").should eq(Rational(1,1))
    Fractional.fractional_from_parts("5","8","144").should eq(Rational(3227,555))
    Fractional.fractional_from_parts("","58","3").should eq(Rational(7,12))
    Fractional.fractional_from_parts("","","012345679").should eq(Rational(1,81))
    Fractional.fractional_from_parts("-0","","3333").should eq(Rational(-1,3))
  end
end

describe "Fractional", "find_repeat" do
  it "should return the repeating decimals in a string" do
    Fractional.find_repeat("1.0333").should eq("3")
    Fractional.find_repeat("0.333").should eq("3")
    Fractional.find_repeat("3.142857142857").should eq("142857")
  end

  it "should return nil when there are not enough repeating decimals" do
    Fractional.find_repeat("1.03").should eq("")
  end
end

describe "Fractional", "find_after_decimal" do
  it "should return the decimal characters after the decimal but before the repeating characters" do
    Fractional.find_after_decimal("1.0333").should eq("0")
    Fractional.find_after_decimal("0.3333").should eq("")
    Fractional.find_after_decimal("0.58333").should eq("58")
  end
end


describe "Fractional", "find_before_decimal" do
  it "should return the decimal characters before the decimal" do
    Fractional.find_before_decimal("1.0333").should eq("1")
    Fractional.find_before_decimal(".3333").should eq("0")
    Fractional.find_before_decimal("-1.4444").should eq("-1")
    Fractional.find_before_decimal("-0.4444").should eq("-0")
  end
end

describe "Fractional", "float_to_rational_repeat" do
  it "should parse a repeating decimal into a fractional value" do
    Fractional.float_to_rational_repeat("0.33").should eq(Rational(1,3))
    Fractional.float_to_rational_repeat(".33").should eq(Rational(1,3))
    Fractional.float_to_rational_repeat("0.8181").should eq(Rational(9,11))
    Fractional.float_to_rational_repeat("3.142857142857").should eq(Rational(22,7))
    Fractional.float_to_rational_repeat("-0.33333").should eq(Rational(-1,3))
  end

  it "should be able to deal with a rounding error at the end of a float value" do
    Fractional.string_to_fraction("3.1666666666666665").should eq(Rational(19,6))
  end

  it "should not be able to parse a non repeating decimal" do
    Fractional.float_to_rational_repeat("1.234").should be_nil
    Fractional.float_to_rational_repeat("1.333312").should be_nil
    Fractional.float_to_rational_repeat("as2342").should be_nil
  end
end


##################################
# Arithematic                    #
##################################

describe "Fractional#+" do
  it "should add with another Fractional" do
    (Fractional.new(Rational(3,4)) + Fractional.new(Rational(1,2))).should == Fractional.new(1.25)
  end

  it "should add with other numerics" do
    (Fractional.new(Rational(-4,5)) + 1).should == Fractional.new(Rational(1,5))
    (Fractional.new("2/3") + 1.2).should == Fractional.new(1.86666666)
    (Fractional.new(1.3) + BigDecimal.new(2)).should == Fractional.new("3.3")
  end

  it "should add with other numerics when other numerics are specified first" do
    (1 + Fractional.new(Rational(-4,5)) ).should == Fractional.new(Rational(1,5))
    (1.2 + Fractional.new("2/3")).should == Fractional.new(1.86666666)
    (BigDecimal.new(2) + Fractional.new(1.3)).should == Fractional.new("3.3")
  end
end

describe "Fractional#-" do
  (1 - Fractional.new(Rational(1,2))).should == Fractional.new(Rational(1,2))
end

describe "Fractional#*" do
  (Fractional.new(Rational(1,2)) * Fractional.new(0.75)).should == Fractional.new(0.375)
end

describe "Fractional#/" do
  (Fractional.new(Rational(4,3)) / Fractional.new(Rational(3,2))).should == Fractional.new(Rational(8,9))
end

describe "Fractional#**" do
  (Fractional.new(8) ** Fractional.new(Rational(1,3))).should == Fractional.new(2)
end

##################################
# comparison                     #
##################################

describe "Fractional#==" do
  it "should be equal to same Fractions" do
    (Fractional.new(Rational(3,1)) == Fractional.new(Rational(3,1))).should be_true
  end

  it "should not be equal to other Fractions" do
    (Fractional.new(Rational(3,2)) == Fractional.new(Rational(3,1))).should be_false
  end

  it "should be equal regardless of type" do
    (Fractional.new(Rational(3,4)) == Fractional.new(0.75)).should be_true
  end
end

describe "Frational#<=>" do
  it "should return 0 if fractions are equal" do
    (Fractional.new(Rational(5,4)) <=> Fractional.new(1.25)).should == 0
  end

  it "should return -1 if the lhs is less" do
    (Fractional.new(Rational(3,4)) <=> Fractional.new(Rational(8,9))).should == -1
  end

  it "should compare to other numerics" do
    (Fractional.new(Rational(-1,2)) <=> -0.5).should == 0
    (Fractional.new(Rational(-1,2)) <=> 1).should == -1
    (Fractional.new(Rational(-1,2)) <=> BigDecimal.new(-2)).should == 1
  end

  it "should work the other way too" do
    ( -0.5 <=> Fractional.new(Rational(-1,2))).should == 0
    (1 <=> Fractional.new(Rational(-1,2))).should == 1
    (BigDecimal.new(-2) <=> Fractional.new(Rational(-1,2))).should == -1
  end

  it "would be nice to compare to strings" do
    (Fractional.new(Rational(1,2)) <=> "3/4").should == -1
    ("3/4" <=> Fractional.new(Rational(1,2))).should == 1
    ("-3/4" <=> Fractional.new(Rational(-1,2))).should == -1
  end
end

describe "Frational", "comparsion" do
  it "should use the numerics included comparsion module" do
    (Fractional.new(Rational(-3,4)) < Fractional.new(Rational(1,2))).should be_true
  end
end

##################################
# conversion                     #
##################################

describe "Fractional#to_s" do
  it "should return nice representations of single fractions" do
    Fractional.new(0.75).to_s.should == "3/4"
    Fractional.new(-0.3333).to_s.should == "-1/3"

  end

  it "should return nice representations of mixed fractions" do
    Fractional.new(1.5).to_s.should == "3/2"
    Fractional.new(-1.3333).to_s.should == "-4/3"
    Fractional.new(0.0).to_s.should == "0/1"
  end

  it "should return mixed number representations if told so" do
    Fractional.new(1.5).to_s(mixed_number: true).should == "1 1/2"
    Fractional.new(Rational(-3,2)).to_s(mixed_number: true).should == "-1 1/2"
    Fractional.new(1.00).to_s(mixed_number: true).should == "1"
    Fractional.new(0.75).to_s(mixed_number: true).should == "3/4"
  end
end

describe "Fractional#to_f" do
  it "should return float representations of fractions" do
    Fractional.new("3/4").to_f.should == 0.75
    Fractional.new("-2/3").to_f.should be_within(0.0000001).of(-0.6666666)
  end
end

describe "Fractional#to_r" do
  it "should return a rational representation" do
    Fractional.new("3/4").to_r.should == Rational(3,4)
  end
end

describe "Fractional#to_i" do
  it "should return a truncated value" do
    Fractional.new("1 3/4").to_i.should == 1
    Fractional.new("-2 1/3").to_i.should == -2
  end
end

describe "Fractional", "round" do

  it "should round 0.142857142857143 to nearest 1/64th as 0.140625" do
    Fractional.round_to_nearest_fraction(0.142857142857143, "1/64").should == Fractional.new(0.140625)
  end

  it "should round '1/7' to nearest 1/64th as '9/64'" do
    Fractional.round_to_nearest_fraction('1/7', "1/64").should == Fractional.new('9/64')
  end

  it "should round 0.125 to nearest 1/64th as 0.125" do
    Fractional.round_to_nearest_fraction(0.125, "1/64").should == Fractional.new(0.125)
  end

  it "should round '1100 1/7' to nearest 1/64th as '1100 9/64'" do
    Fractional.round_to_nearest_fraction('1100 1/7', "1/64").should == Fractional.new('70409/64')
  end

  it "should round 1100.142857142857143 to nearest 1/64th as 1100.140625" do
    Fractional.round_to_nearest_fraction(1100.142857142857143, "1/64").should == Fractional.new(1100.140625)
  end

  it "should round if passed 'to_nearest' that rounds to nearest whole number" do
    Fractional.round_to_nearest_fraction(1100.875, "1/2").should == Fractional.new(1101)
    Fractional.round_to_nearest_fraction(1100.1, "1/2").should == Fractional.new(1100)
  end

  it "should round if passed a float" do
    Fractional.round_to_nearest_fraction(1100.875, 0.5).should == Fractional.new(1101)
  end
end

##################################
# misc                           #
##################################

describe 'Fractional#whole_part' do
  it "should return the whole part, if it exists, of a fraction" do
    Fractional.new(Rational(3,2)).whole_part.should eq(1)
    Fractional.new(Rational(-3,2)).whole_part.should eq(-1)
    Fractional.new(Rational(1,2)).whole_part.should eq(0)
  end
end

describe 'Fractional#fractional_part' do
  it "should return the fractional part, if it exists, of a fraction" do
    Fractional.new(Rational(3,2)).fractional_part.should eq(Fractional.new(Rational(1,2)))
    Fractional.new(Rational(-3,2)).fractional_part.should eq(Fractional.new(Rational(-1,2)))
    Fractional.new(Rational(1,2)).fractional_part.should eq(Fractional.new(Rational(1,2)))
    Fractional.new(Rational(2,2)).fractional_part.should eq(Fractional.new(0))
  end
end


##################################
# deprecated methods             #
##################################
# remove in v1.1
describe "deprecated methods" do
  it "Fractional.to_f" do
    Fractional.to_f(1.5).should == 1.5
  end

  it "Fractional.to_s" do
    Fractional.to_s(0.5).should == '1/2'
    Fractional.to_s(-0.140625, :to_nearest => "1/64").should == "-9/64"
  end

  it "Fraction.fraction?" do
    Fractional.fraction?("3/4").should be_true
  end

  it "Fraction.mixed_fraction?" do
    Fractional.mixed_fraction?("1 11/12").should be_true
  end

  it "Fraction.single_fraction?" do
     Fractional.single_fraction?("-3/4").should be_true
  end
end