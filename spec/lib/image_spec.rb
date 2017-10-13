require "spec_helper"

RSpec.describe Image do
  it { expect(Image).to respond_to(:all) }

  describe ".all" do
    it "returns an empty array when there are no images on disk" do
      expect(Image.all.size).to eq(0)
    end

    it "returns an array of image names when there are images on disk" do
      image1_name = add_image_to_disk!
      image2_name = add_image_to_disk!

      images = Image.all

      expect(images.size).to eq(2)
      expect(images).to include(filename: image1_name)
      expect(images).to include(filename: image2_name)
    end
  end
end
