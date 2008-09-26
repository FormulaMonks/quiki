require File.dirname(__FILE__) + '/../spec_helper'

describe Destination do
  before(:each) do
    @destination = Destination.new
  end

  it "should be valid" do
    @destination.should be_valid
  end
end
