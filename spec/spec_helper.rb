require "bundler/setup"
require "pry"
require "rack/test"
require "rspec"

DATA_DIRECTORY = "./spec/data".freeze
IMAGES_DIRECTORY = "./spec/support/images".freeze
BASE64_DIRECTORY = "./spec/support/base64".freeze

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

  config.before(:suite) do
    Dir.mkdir(DATA_DIRECTORY) unless Dir.exist?(DATA_DIRECTORY)
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

def add_image_to_disk!(filename = nil)
  image = if filename
            "#{IMAGES_DIRECTORY}/#{filename}"
          else
            unique_image_from_datafiles
          end
  basename = File.basename(image)
  FileUtils.cp(image, "#{DATA_DIRECTORY}/#{basename}")
  basename
end

def unique_image_from_datafiles
  images = Dir.glob("#{IMAGES_DIRECTORY}/*.{jpg,png}")
  images.size.times do
    image = images.sample
    return image unless File.exist?("#{DATA_DIRECTORY}/#{File.basename(image)}")
  end
end

def data_exist?(name)
  data_files.any? do |file|
    file.include?(File.basename(name))
  end
end

def data_files
  Dir.glob("#{DATA_DIRECTORY}/*.{jpg,png}")
end
