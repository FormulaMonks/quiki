require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationController do
  describe "site constants" do
    it "should give Quiki for header" do
      controller.site_config(:header).should eql('Quiki')
    end
    
    it "should give ...get some! for byline" do
      controller.site_config(:byline).should eql('...get some!')
    end
  end
end
