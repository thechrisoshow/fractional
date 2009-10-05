require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Fractional", "to_f" do
  
  it "should parse '1/2' to 0.5" do
    Fractional.to_f('1/2').should == 0.5
  end
  
  it "should parse '1 2/4' to 1.5" do
    Fractional.to_f('1 2/4').should == 1.5
  end
  
  it "should parse '1.5' to 1.5" do
    Fractional.to_f('1.5').should == 1.5    
  end

  it "should parse 1.5 to 1.5" do
    Fractional.to_f(1.5).should == 1.5    
  end
  
  it "should parse '1100 7/8' to 1100.875" do
    Fractional.to_f("1100 7/8").should == 1100.875
  end
  
  it "should allow for negative mixed fractions" do
    Fractional.to_f('-10 1/2').should == -10.5    
  end
  
  it "should allow for negative single fractions" do
    Fractional.to_f("-1/64").should == -0.015625
  end
  
end

describe "Fractional", "to_s" do
  
  it "should return 0.5 as '1/2'" do
    Fractional.to_s(0.5).should == '1/2'
  end
  
  it "should return 1.5 as '1 1/2'" do
    Fractional.to_s(1.5).should == '1 1/2'
  end
    
  it "should parse 1100.875 to '1100 7/8'" do
    Fractional.to_s(1100.875).should == "1100 7/8"
  end

  it "should not have a fraction if it's just a whole number" do
    Fractional.to_s(1100).should == "1100"    
  end
  
  it "should round if passed 'to nearest'" do
    Fractional.to_s(1100.14285714286, :to_nearest => "1/64").should == "1100 9/64"
  end
  
  it "should round if passed 'to_nearest' and is a simple fraction" do
    Fractional.to_s(0.14285714286, :to_nearest => "1/64").should == "9/64"
  end
  
  it "should round if passed 'to_nearest' that rounds to nearest whole number" do
    Fractional.to_s(1100.875, :to_nearest => "1/2").should == "1101"
    Fractional.to_s(1100.2, :to_nearest => "1/2").should == "1100"
  end
  
  it "should allow for negative values for mixed fractions" do
    Fractional.to_s(-1100.875).should == "-1100 7/8"
  end
  
  it "should allow for negative values for single fractions" do
    Fractional.to_s(-0.875).should == "-7/8"
  end
  
  it "should allow for negative mixed fractions that that are rounded" do
    Fractional.to_s(-101.140625, :to_nearest => "1/64").should == "-101 9/64"
  end
  
  it "should allow for negative single fractions that that are rounded" do
    Fractional.to_s(-0.140625, :to_nearest => "1/64").should == "-9/64"
  end
  
  
end

describe "Fractional", "round" do
  
  it "should round 0.142857142857143 to nearest 1/64th as 0.140625" do
    Fractional.round_to_nearest_fraction(0.142857142857143, "1/64").should == 0.140625
  end

  it "should round '1/7' to nearest 1/64th as '9/64'" do
    Fractional.round_to_nearest_fraction('1/7', "1/64").should == '9/64'
  end
  
  it "should round 0.125 to nearest 1/64th as 0.125" do
    Fractional.round_to_nearest_fraction(0.125, "1/64").should == 0.125
  end

  it "should round '1100 1/7' to nearest 1/64th as '1100 9/64'" do
    Fractional.round_to_nearest_fraction('1100 1/7', "1/64").should == '1100 9/64'
  end
  
  it "should round 1100.142857142857143 to nearest 1/64th as 1100.140625" do
    Fractional.round_to_nearest_fraction(1100.142857142857143, "1/64").should == 1100.140625
  end
  
  it "should round if passed 'to_nearest' that rounds to nearest whole number" do
    Fractional.round_to_nearest_fraction(1100.875, "1/2").should == 1101
    Fractional.round_to_nearest_fraction(1100.1, "1/2").should == 1100    
  end
end
