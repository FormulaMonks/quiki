require File.dirname(__FILE__) + '/../spec_helper'

class Foo;end;
class Bar;end;
class Baz;end;

describe Object do
  describe "is_a?" do
    before :each do
      @foo = Foo.new
    end
  
    it "should be Foo" do
      @foo.is_a?(Foo).should be_true
    end
  
    it "should be one of Bar or Foo" do
      @foo.is_a?(Bar, Foo).should be_true
    end
  
    it "should not be one of Bar or Baz" do
      @foo.is_a?(Bar, Baz).should be_false
    end
  end
end
