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
  
end