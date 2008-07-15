require File.dirname(__FILE__) + '/../spec_helper'

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
  
  describe "creating" do
    describe "naming" do
      before :each do
        @page = Page.create! :title => 'Foo Bar Baz', :body => '*foo bar*', :parser => 'markdown'
      end
      
      it "should use Foo-Bar-Baz for the pages path" do
        @page.path.should eql('Foo-Bar-Baz')
      end
    end
    
    describe "parsing" do
      before :each do
        @page = Page.new :title => 'foo', :body => '*foo bar*', :parser => 'markdown'
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
        @page.parser = nil
        @page.save!
        @page.rendered.should eql('*foo bar*')
      end
      
      it "should only render once" do
        @page.should_receive(:render).once
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
      
      describe "with multiple code blocks and text" do
        before :each do
        end

        def body
          # this is built in an array to avoid extra spacing which has meaning to
          # the parser
          [
            "*foo bar baz*",
            "-:ruby",
            "10000000000000.times do",
            "  puts '*foo bar*'",
            "end",
            "-:ruby",
            "*bing bang boom*",
            "-:javascript",
            "console.info('Hello World');",
            "-:javascript",
            "_blah blah blah_"
          ].join("\n")
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
        
        describe "accessing code source" do
          it "should return the ruby block" do
            @page.save!
            @page.reload
            @page.code_blocks[0].language.should eql('ruby')
          end

          it "should return the javascript block" do
            @page.save!
            @page.reload
            @page.code_blocks[1].language.should eql('javascript')
          end
        end
      end
    end
    
    describe "validating" do
      before :each do
        pending "don't really care about this yet..."
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
        @page.errors.on(:body).should =~ /mismatched/
      end
    end    
  end
end