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
  describe "finding" do
    before :each do
      @page = Page.create! :title => 'Foo', :body => BODY
    end
    
    describe "types" do
      it "should find all the languages used in code blocks and their associated appearance counts" do
        CodeBlock.languages.collect{ |l| l.language }.should eql(['javascript', 'ruby'])
      end
    end
  end
end