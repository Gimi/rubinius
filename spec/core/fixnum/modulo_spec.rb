require File.dirname(__FILE__) + '/../../spec_helper'

fixnum_modulo = shared "Fixnum#%" do |cmd|
  describe "Fixnum##{cmd}" do
    it "returns the modulus obtained from dividing self by the given argument" do
      13.send(cmd, 4).should == 1
      4.send(cmd, 13).should == 4
  
      13.send(cmd, 4.0).should == 1
      4.send(cmd, 13.0).should == 4
  
      1.send(cmd, 2.0).should == 1.0
      200.send(cmd, 0xffffffff).should == 200
    end

    it "raises a ZeroDivisionError when the given argument is 0" do
      should_raise(ZeroDivisionError, "divided by 0") do
        13.send(cmd, 0)
      end
  
      should_raise(ZeroDivisionError, "divided by 0") do
        0.send(cmd, 0)
      end
      
      should_raise(ZeroDivisionError, "divided by 0") do
        -10.send(cmd, 0)
      end
    end

    it "does not raise a FloatDomainError when the given argument is 0 and a Float" do
      0.send(cmd, 0.0).to_s.should == "NaN" 
      10.send(cmd, 0.0).to_s.should == "NaN" 
      -10.send(cmd, 0.0).to_s.should == "NaN" 
    end

    it "raises a TypeError when given a non-Integer" do
      should_raise(TypeError, "Object can't be coerced into Fixnum") do
        (obj = Object.new).should_receive(:to_int, :count => 0, :returning => 10)
        13.send(cmd, obj)
      end
      
      should_raise(TypeError, "String can't be coerced into Fixnum") do
        13.send(cmd, "10")
      end
  
      should_raise(TypeError, ":symbol can't be coerced into Fixnum") do
        13.send(cmd, :symbol)
      end
    end
  end
end

describe "Fixnum#%" do
  it_behaves_like(fixnum_modulo, :%)
end

describe "Fixnum#modulo" do
  it_behaves_like(fixnum_modulo, :modulo)
end
