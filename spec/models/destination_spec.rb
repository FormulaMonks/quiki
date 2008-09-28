require File.dirname(__FILE__) + '/../spec_helper'

describe Destination do
  describe "url with login credentials" do
    before :each do
      @destination = Destination.new :url => 'https://foo:barbang@example.com/'
    end
    
    it "should mask the login info" do
      @destination.masked_url.should eql('https://foo:xxx@example.com/')
    end
  end
  
  describe "url without login credentials" do
    before :each do
      @destination = Destination.new :url => 'https://www.example.com/'
    end
    
    it "should show the url intact" do
      @destination.masked_url.should eql('https://www.example.com/')
    end
  end
end
