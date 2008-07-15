require File.dirname(__FILE__) + '/../spec_helper'

describe Section do
  describe "deleting" do
    before :each do
      @section = Section.create! :name => 'foo'
      @foo = @section.pages.add! Page.new(:title => 'foo')
      @section.destroy
    end
    
    it "should not destroy the page" do
      Page.count(:all).should be(1)
    end
    
    it "should nullify the page's foreign key" do
      @foo.reload.section_id.should be_nil
    end
  end
end