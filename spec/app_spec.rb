require "spec_helper"

RSpec.describe "Routehappy API" do
  it "can upload a file using the POST /image route" do
    image = unique_image_from_datafiles
    expect(data_exist?(image)).to eq(false)

    post "/image", file: Rack::Test::UploadedFile.new(image, "image/#{img_type(image)}")

    expect(last_response).to be_ok
    expect(data_exist?(image)).to eq(true)
  end

  it "returns a 500 if the image can't save" do
    post "/image", file: {}
    expect(last_response.status).to eq(500)
  end

  it "responds to GET /images" do
    get "/images"
    expect(last_response).to be_ok
  end

  it "can return a list of filenames that are on disk" do
    image1_name = add_image_to_disk!
    image2_name = add_image_to_disk!

    get "/images"

    body = JSON.parse(last_response.body)["images"]
    expect(body.size).to eq(2)
    expect(body).to include(include("filename" => image1_name))
    expect(body).to include(include("filename" => image2_name))
  end

  it "can return base64 encoded image data" do
    image1_name = add_image_to_disk!
    image2_name = add_image_to_disk!

    get "/images"

    body = JSON.parse(last_response.body)["images"]
    expect(body.size).to eq(2)
    expect(body).to include(include("content" => base64_img_src(image1_name)))
    expect(body).to include(include("content" => base64_img_src(image2_name)))
  end

  it "can return file names and base64 encoded image data" do
    image1_name = add_image_to_disk!
    image2_name = add_image_to_disk!

    get "/images"

    body = JSON.parse(last_response.body)["images"]
    expect(body.size).to eq(2)
    expect(body).to include("filename" => image1_name, "content" => base64_img_src(image1_name))
    expect(body).to include("filename" => image2_name, "content" => base64_img_src(image2_name))
  end

  def base64_img_src(name)
    "data:image/#{img_type(name)};base64,#{base64_img(name)}"
  end

  def img_type(name)
    File.extname(name).strip.downcase[1..-1]
  end

  def base64_img(name)
    Base64.encode64(File.open("#{DATA_DIRECTORY}/#{name}").read)
  end
end
