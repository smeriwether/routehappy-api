require "sinatra"
require "sinatra/json"
require "json"
require "base64"

require_relative "lib/image"

get "/images" do
  json images: Image.all
end

post "/image" do
  image = Image.new(image_params)
  image.save
end

def image_params
  {
    filename: params.dig(:file, :filename),
    data: params.dig(:file, :tempfile),
  }
end
