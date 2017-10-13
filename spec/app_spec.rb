require "spec_helper"

RSpec.describe "Routehappy API" do
  it "responds to /images" do
    get "/images"
    expect(last_response).to be_ok
  end

  it "can return a list of filenames that are on disk" do
    image1_name = add_image_to_disk!
    image2_name = add_image_to_disk!

    get "/images"

    body = JSON.parse(last_response.body)["images"]
    expect(body.size).to eq(2)
    expect(body).to include("filename" => image1_name)
    expect(body).to include("filename" => image2_name)
  end
end
