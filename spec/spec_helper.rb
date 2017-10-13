require "bundler/setup"
require "pry"
require "rack/test"
require "rspec"

DATA_DIRECTORY = "./spec/data".freeze
DATAFILES_DIRECTORY = "./spec/support/datafiles/".freeze

ENV["RACK_ENV"] = "test"
ENV["DATA_DIRECTORY"] = DATA_DIRECTORY

require File.expand_path "../../app.rb", __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Tests create test images so we need to clear the data directory
  # to give the next test a clean slate.
  config.after(:each) do
    clear_data_directory!
  end
end

def clear_data_directory!
  FileUtils.rm_rf Dir.glob("#{DATA_DIRECTORY}/*")
end

def add_image_to_disk!
  image = unique_image_from_datafiles
  basename = File.basename(image)
  FileUtils.cp(image, "#{DATA_DIRECTORY}/#{basename}")
  basename
end

def unique_image_from_datafiles
  images = Dir.glob("#{DATAFILES_DIRECTORY}/*")
  images.size.times do
    image = images.sample
    return image unless File.exist?("#{DATA_DIRECTORY}/#{File.basename(image)}")
  end
end