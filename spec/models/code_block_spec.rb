require File.dirname(__FILE__) + '/../spec_helper'

BODY = <<-BODY
_bing bang boom_
-:javascript
  console.info('blah');
-:javascript
*foo bar baz*
-:ruby
  100.times.do
    puts 'Hello World'
  end
-:ruby
_zing zang zong_
BODY

describe CodeBlock do
  describe "finding by type" do
    before :each do
      @page = Page.create! :title => 'Foo', :body => BODY
    end
    
    it "should find 1 javascript block" do
      CodeBlock.find('javascript').length.should be(1)
    end
  end
end