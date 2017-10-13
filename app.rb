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
  if image.save
    status 200
  else
    status 500
  end
end

def image_params
  {
    filename: params.dig(:file, :filename),
    data: params.dig(:file, :tempfile),
  }
end
