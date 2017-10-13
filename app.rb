require "sinatra"
require "sinatra/json"
require "json"
require "base64"

require_relative "lib/image"

get "/images" do
  json images: Image.all
end
