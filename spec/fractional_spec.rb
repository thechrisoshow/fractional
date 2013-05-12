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

end

describe "Fractional::float_to_fractional" do
  it "should parse simple decimals" do
    Fractional.float_to_fraction(0.5).should == Fractional.new(Rational(1,2))
    Fractional.float_to_fraction(1.5).should == Fractional.new(Rational(3,2))
    Fractional.float_to_fraction(1100).should == Fractional.new(Rational(1100,1))
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

  #it "should allow for negative mixed fractions that that are rounded" do
    #Fractional.float_to_fraction(-101.140625, :to_nearest => "1/64").should == "-101 9/64"
  #end

  #it "should allow for negative single fractions that that are rounded" do
    #Fractional.float_to_fraction(-0.140625, :to_nearest => "1/64").should == "-9/64"
  #end

  #it "should round if passed 'to nearest'" do
    #Fractional.float_to_fraction(1100.14285714286, :to_nearest => "1/64").should == "1100 9/64"
  #end

  #it "should round if passed 'to_nearest' that is a float" do
    #Fractional.float_to_fraction(1100.14285714286, :to_nearest => 0.015625).should == "1100 9/64"
  #end

  #it "should round if passed 'to_nearest' and is a simple fraction" do
    #Fractional.float_to_fraction(0.14285714286, :to_nearest => "1/64").should == "9/64"
  #end

  #it "should round if passed 'to_nearest' that rounds to nearest whole number" do
    #Fractional.float_to_fraction(1100.875, :to_nearest => "1/2").should == "1101"
    #Fractional.float_to_fraction(1100.2, :to_nearest => "1/2").should == "1100"
  #end

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


##################################
# Arithematic                    #
##################################

describe "Fractional#+" do

end

describe "Fractional#-" do

end

describe "Fractional#*" do

end

describe "Fractional#/" do

end

describe "Fractional#**" do

end

##################################
# equality                       #
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

##################################
# conversion                     #
##################################

describe "Fractional#to_s" do

end

describe "Fractional#to_f" do

end

describe "Fractional#to_r" do

end

describe "Fractional#to_i" do

end

describe "Fractional", "round" do

  #it "should round 0.142857142857143 to nearest 1/64th as 0.140625" do
    #Fractional.round_to_nearest_fraction(0.142857142857143, "1/64").should == 0.140625
  #end

  #it "should round '1/7' to nearest 1/64th as '9/64'" do
    #Fractional.round_to_nearest_fraction('1/7', "1/64").should == '9/64'
  #end

  #it "should round 0.125 to nearest 1/64th as 0.125" do
    #Fractional.round_to_nearest_fraction(0.125, "1/64").should == 0.125
  #end

  #it "should round '1100 1/7' to nearest 1/64th as '1100 9/64'" do
    #Fractional.round_to_nearest_fraction('1100 1/7', "1/64").should == '1100 9/64'
  #end

  #it "should round 1100.142857142857143 to nearest 1/64th as 1100.140625" do
    #Fractional.round_to_nearest_fraction(1100.142857142857143, "1/64").should == 1100.140625
  #end

  #it "should round if passed 'to_nearest' that rounds to nearest whole number" do
    #Fractional.round_to_nearest_fraction(1100.875, "1/2").should == 1101
    #Fractional.round_to_nearest_fraction(1100.1, "1/2").should == 1100
  #end

  #it "should round if passed a float" do
    #Fractional.round_to_nearest_fraction(1100.875, 0.5).should == 1101
  #end
end

