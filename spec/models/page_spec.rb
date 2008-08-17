require File.dirname(__FILE__) + '/../spec_helper'

BODY = <<-BODY
*foo bar baz*
-:ruby
10000000000000.times do
  puts '*foo bar*'
end
-:ruby
*bing bang boom*
-:javascript
console.info('Hello World');
-:javascript
_blah blah blah_
BODY

DOT_BODY = <<-DOTBODY
*foo bar baz*
-:ruby
10000000000000.times do
  puts '*foo bar*'
end
-:ruby
*bing bang boom*
-:javascript
console.info('Hello World');
-:javascript
_blah blah blah_
::
graph ER {
  fontsize=20;
}
::
-blahdy blah blah
DOTBODY

DOT_BODY_ALONE = <<-DOTBODYALONE
*foo bar baz*
::
graph ER {
  fontsize=20;
}
::
_blah blah blah_
DOTBODYALONE

DOT_BEFORE_CODE = <<-DOTBEFORECODE
*foo bar baz*
::
graph ER {
  fontsize=20;
}
::
*bing bang boom*
-:javascript
console.info('Hello World');
-:javascript
_blah blah blah_
DOTBEFORECODE

describe Page do
  describe "finding" do
    describe "excluding home" do
      before :each do
        @home = Page.create! :title => 'Home'
        @foo  = Page.create! :title => 'foo'
      end
      
      it "should not include home" do
        Page.without_home.should_not include(@home)
      end
    end
    
    describe "orphaned" do
      before :each do
        @section = Section.create! :name => 'foo'
        @foo = @section.pages.add! Page.new(:title => 'foo')
        @bar = Page.create! :title => 'bar'
      end
      
      it "should not include foo" do
        Page.orphaned.should_not include(@foo)
      end
    end
    
    describe "excluding home and orphaned" do
      before :each do
        @section = Section.create! :name => 'foo'
        @home = Page.create! :title => 'Home'
        @foo  = @section.pages.add! Page.new(:title => 'foo')
        @bar  = Page.create! :title => 'bar'
      end
      
      it "should not include foo or home" do
        Page.orphaned.without_home.should_not include(@home)
        Page.orphaned.without_home.should_not include(@foo)
      end
    end
    
    describe "recent" do
      before :each do
        @pages = []
        %w( foo bar baz ).each do |page|
          @pages << Page.create!(:title => page)
        end
      end
      
      it "should find pages in order of recent update" do
        Page.recent.should eql(@pages.reverse)
      end
    end
  end
  
  describe "updating" do
    before :each do
      @page = Page.create! :title => 'Foo', :body => BODY
      @page.reload
    end
    
    it "should save page" do
      lambda {
        @page.save!
      }.should_not raise_error
    end
    
    it "should only have two code blocks" do
      @page.save!
      @page.reload.code_blocks.size.should be(2)
    end
    
    it "should not have deleted the old code blocks" do
      @page.save!
      CodeBlock.count(:all).should be(4)
    end
    
    it "should have attached the older code blocks to previous version" do
      @page.save!
      @page.versions.find_by_version(1).code_blocks.length.should be(2)
    end
    
    it "should have 2 versions" do
      @page.save!
      Page::Version.count(:all).should be(2)
    end    
  end
  
  describe "creating" do
    describe "with versions" do
      before :each do
        @page = Page.create! :title => 'Foo Bar Baz', :body => BODY
      end
      
      it "should only save 1 version of the page" do
        @page.reload.versions.length.should be(1)
      end
    end
    
    describe "naming" do
      before :each do
        @page = Page.create! :title => 'Foo Bar Baz', :body => '*foo bar*', :parser => 'markdown'
      end
      
      it "should use Foo-Bar-Baz for the pages path" do
        @page.path.should eql('Foo-Bar-Baz')
      end

      describe "when one page has crazy characters" do
        before :each do
          @foo = Page.new :title => "~!@\#$%^&*()+`={}[]|\\:\"<>?;',./Foo Bar Baz"
        end
        
        it "should not allow @foo to be saved" do
          lambda {
            @foo.save!
          }.should raise_error
        end
        
        it "should raise error about similar page" do
          @foo.save
          @foo.errors.on(:title).should =~ /same.*Foo Bar Baz/
        end
      end
    end
      
    describe "with crazy characters in name" do
      before :each do
        @page = Page.create! :title => "~!@\#$%^&*()+`={}[]|\\:\"<>?;',./Foo Bar Baz"
      end
      
      it "should use Foo-Bar-Baz for the pages path" do
        @page.path.should eql('Foo-Bar-Baz')
      end
    end

    describe "parsing" do
      before :each do
        @page = Page.new :title => 'foo', :body => '*foo bar*'
      end
      
      it "should render the contents of the page" do
        @page.save!
        @page.rendered.should eql("<p><em>foo bar</em></p>\n")
      end
    
      it "should render the contents of the page using markdown" do
        @page.save!
        @page.rendered.should eql("<p><em>foo bar</em></p>\n")
      end

      it "should render the contents of the page using textile" do
        @page.parser = 'textile'
        @page.save!
        @page.rendered.should eql('<p><strong>foo bar</strong></p>')
      end

      it "should render the contents of the page using html_parser" do
        @page.parser = 'html'
        @page.save!
        @page.rendered.should eql('*foo bar*')
      end
      
      it "should only render once" do
        @page.should_receive(:render).twice
        @page.save!
      end
    end
    
    describe "syntax highlighting" do
      before :each do
        @page = Page.new :title => 'foo', :body => body, :parser => 'markdown'
      end

      def body
        # this is built in an array to avoid extra spacing which has meaning to
        # the parser
        [
          "foo bar baz",
          "-:ruby",
          "10000000000000.times do",
          "  puts '*foo bar*'",
          "end",
          "-:ruby",
          "*bing bang boom*"
        ].join("\n")
      end

      it "should highlight the ruby section" do
        @page.save!
        @page.rendered.should =~ /<pre class=.*?>.*10000000000000.*<\/pre>/m
      end

      it "should not apply markdown inside of the the ruby section" do
        @page.save!
        @page.rendered.should_not =~ /<em>foo bar<\/em>/
      end

      it "should apply markdown outside of the the ruby section" do
        @page.save!
        @page.rendered.should =~ /<em>bing bang boom<\/em>/
      end
      
      describe "with invalid syntax highlighter block" do
        before :each do
          @page.body += [
            "\n-:foo",
            "  foo",
            "-:foo\n"
          ].join("\n")
        end
        
        it "should not raise error with invalid syntax given" do
          lambda {
            @page.save
          }.should_not raise_error
        end
      
        it "should not save the page with invalid syntax given" do
          @page.save.should be_false
        end
      end
      
      # TODO: run the whole suite for BODY and DOT_BODY
      [ 'BODY', 'DOT_BODY' ].each do |body|
        describe "with multiple code blocks in #{body} and text" do
          before :each do
            DotBlock.stub!(:new).and_return(@dot_block = mock_model(DotBlock, :render! => 'foo.png'))
            @page.body = body.constantize
          end

          it "should render the starting text" do
            @page.save!
            @page.rendered.should =~ /<em>foo bar baz<\/em>/
          end

          it "should highlight the ruby section" do
            @page.save!
            @page.rendered.should =~ /<pre class=.*?>.*10000000000000.*<\/pre>/m
          end

          it "should render the middle text" do
            @page.save!
            @page.rendered.should =~ /<em>bing bang boom<\/em>/
          end

          it "should highlight the javascript section" do
            @page.save!
            @page.rendered.should =~ /<pre class=.*?>.*console.*<\/pre>/m
          end

          it "should render the trailing text" do
            @page.save!
            @page.rendered.should =~ /<em>blah blah blah<\/em>/
          end
        end
      end
      
      describe "with DOT code block" do
        before :each do
          DotBlock.stub!(:new).and_return(@dot_block = mock_model(DotBlock, :render! => 'foo.png'))
          @page.body = DOT_BODY
        end
        
        it "should not show the DOT code in the output" do
          @page.save!
          @page.rendered.should_not =~ /::/
        end
        
        it "should create a new DOT block for DOT code" do
          DotBlock.should_receive(:new).any_number_of_times.and_return(@dot_block)
          @page.save!
        end
        
        it "should render! the DOT block" do
          @dot_block.should_receive(:render!).and_return('foo.png')
          @page.save!
        end
        
        it "should embed image" do
          @page.save!
          @page.rendered.should =~ /<img src=\"foo.png\" \/>/
        end
      end
      
      describe "with only DOT code block" do
        before :each do
          DotBlock.stub!(:new).and_return(@dot_block = mock_model(DotBlock, :render! => 'foo.png'))
          @page.body = body
          @page.save!
        end
        
        def body
          DOT_BODY_ALONE
        end
        
        it "should render the starting text" do
          @page.rendered.should =~ /<em>foo bar baz<\/em>/
        end

        it "should render the DOT block" do
          @page.rendered.should =~ /<img src.*?\/>/
        end

        it "should render the ending text" do
          @page.rendered.should =~ /<em>blah blah blah<\/em>/
        end
        
        describe "with code after DOT block" do
          def body
            DOT_BEFORE_CODE
          end

          it "should render the code block" do
            @page.rendered.should =~ /<pre class=.*?>.*console.*<\/pre>/m
          end
        end
      end
    end
    
    describe "validating" do
      before :each do
        # this is built in an array to avoid extra spacing which has meaning to
        # the parser
        body = [
          "foo",
          "-:ruby",
          "bang",
          "-:javascript",
          "bar"
        ].join("\n")
        @page = Page.new :title => 'foo', :body => body, :parser => 'markdown'
      end
      
      it "should not save the page" do
        @page.save.should be_false
      end
      
      it "should have an error on the body about mismatched tags" do
        @page.save
        @page.errors.on(:body).should =~ /mismatched/
      end
    end
    
    describe "outputting" do
      before :each do
        @page = Page.create! :title => "<blink>Foo</blink>"
      end
      
      it "should html escape the to_s method" do
        @page.to_s.should eql("&lt;blink&gt;Foo&lt;/blink&gt;")
      end
    end
  end
end