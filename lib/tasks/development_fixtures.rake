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
  end
end
