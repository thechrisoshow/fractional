require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Fractional" do

  it "should create a fractional object from a string" do
    one_half = Fractional.new("1/2")
  end

  it "should create a fractional object from a string" do
    one_half = Fractional.new("1/2")
  end

  it "should create a fractional object from a string" do
    one_half = Fractional.new("1/2")
  end
  
  it "should convert fractional to string" do
    one_half = Fractional.new("1/2")
    one_half.to_s.should == "1/2"
  end
  
  it "should convert fractional to float" do
    one_half = Fractional.new("1/2")
    one_half.to_f.should == 0.5
  end
  
  it "should add two fractionals together" do
    one_half = Fractional.new("1/2")
    another_one_half = Fractional.new("1/2")
    
    (one_half + another_one_half).to_f.should == 1.0
  end

  it "should minus a fractional from another fractional" do
    one_and_a_half = Fractional.new("1 1/2")
    one_quarter = Fractional.new("1/4")
    
    (one_and_a_half - one_quarter).to_f.should == 1.25
  end

  it "should multiply 2 fractionals together" do
    first_fraction = Fractional.new("1 7/8")
    second_fraction = Fractional.new("11 15/64")
    
    (first_fraction * second_fraction).to_f.should == 21.064453125
  end
  
  it "should divide 2 fractionals together" do
    first_fraction = Fractional.new("1 7/8")
    second_fraction = Fractional.new("21 33/512")
    
    (second_fraction / first_fraction).to_s.should == "11 15/64"
  end
end