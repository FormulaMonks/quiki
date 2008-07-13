require 'active_record'
require 'active_record/fixtures'
require 'action_controller'
require 'action_controller/test_process'
namespace :db do
  namespace :fixtures do
    desc "Fixtures are loaded from db/fixtures."
    task :load => :environment do
      require 'rubygems'
      require 'faker'
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(RAILS_ROOT, 'db', 'fixtures', '*.{yml,csv}'))).each do |fixture_file|
        fixture_file = fixture_file.gsub(RAILS_ROOT + '/', '')
        Fixtures.create_fixtures(File.dirname(fixture_file), File.basename(fixture_file, '.*'))
      end
    end      

    desc "Intermediate task for counter caches"
    task :update_counter_caches => :load do
      Topic.find(:all).each do |t|
        t.posts_count = t.posts.length
        t.save
      end
    end

    desc "Creates attachments (careful, eats up disk space)"
    task :create_attachments => :update_counter_caches do
      users = User.find(:all, :order => 'RANDOM()', :limit => 50)
      video_pages = VideoPage.find(:all)
      for i in (1..50) do
        @avatar = Avatar.create! image_attachment('Avatar')
        users.pop.avatar = @avatar
      end
      video_pages.each do |video_page|
        @screenshot = Screenshot.create! image_attachment
        @video = Video.create! video_attachment.merge(:screenshot => @screenshot)
        video_page.video = @video
      end
    end
  end
end
  
FIXTURE_PATH = "#{RAILS_ROOT}/db/fixtures/"

def image_attachment(type='Image')
  {:file_data => ActionController::TestUploadedFile.new(
    @file = FIXTURE_PATH + %w(big_and_long.jpg big_and_tall.png small_and_long.jpg small_and_tall.jpg).rand, "image/#{@file.split('.')[1]}"),
   :title => "Image #{Faker::Name.name}",
   :type => type}
end

def video_attachment
  {:file_data => ActionController::TestUploadedFile.new(
     FIXTURE_PATH + 'barsandtone.flv', "video/x-flv"),
   :title => "Video #{Faker::Name.name}",
   :type => 'Video'}
end

