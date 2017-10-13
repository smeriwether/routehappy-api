require "spec_helper"

RSpec.describe Image do
  it { expect(Image).to respond_to(:all) }

  describe ".all" do
    it "returns an empty array when there are no images on disk" do
      expect(Image.all.size).to eq(0)
    end

    it "returns an array of hashes that includes 'filenames' when there are images on disk" do
      image1_name = add_image_to_disk!
      image2_name = add_image_to_disk!

      images = Image.all

      expect(images.size).to eq(2)
      expect(images).to include(include(filename: image1_name))
      expect(images).to include(include(filename: image2_name))
    end

    it "returns an array of hashes that includes 'content' when there are images on disk" do
      add_image_to_disk!("C6e-WbbWcAAmu7Q.jpg-large.jpg")

      images = Image.all

      base64_data = File.open("#{BASE64_DIRECTORY}/C6e-WbbWcAAmu7Q.jpg-large.base64.txt").read
      expect(images).to include(include(content: "data:image/jpg;base64,#{base64_data}"))
    end

    it "returns an array of hashes that include 'filename' and 'content'" do
      image_name = add_image_to_disk!("C6e-WbbWcAAmu7Q.jpg-large.jpg")

      images = Image.all

      base64_data = File.open("#{BASE64_DIRECTORY}/C6e-WbbWcAAmu7Q.jpg-large.base64.txt").read
      expect(images).to include(
        filename: image_name,
        content: "data:image/jpg;base64,#{base64_data}",
      )
    end

    it "rejects file types that aren't jpg or png" do
      add_image_to_disk!("not-image.txt")
      expect(Image.all.size).to eq(0)
    end
  end

  describe ".base64" do
    it "can base64 png" do
      image_name = "#{DATA_DIRECTORY}/#{add_image_to_disk!('Cmx9OGFXgAAkh60.png')}"
      base64_data = File.open("#{BASE64_DIRECTORY}/Cmx9OGFXgAAkh60.png.base64.txt").read

      expect(Image.base64(image_name)).to eq(base64_data)
    end

    it "can base64 jpg" do
      image_name = "#{DATA_DIRECTORY}/#{add_image_to_disk!('C6e-WbbWcAAmu7Q.jpg-large.jpg')}"
      base64_data = File.open("#{BASE64_DIRECTORY}/C6e-WbbWcAAmu7Q.jpg-large.base64.txt").read

      expect(Image.base64(image_name)).to eq(base64_data)
    end
  end

  describe ".extension" do
    it { expect(Image.extension("foo.jpg")).to eq("jpg") }
    it { expect(Image.extension("foo.png")).to eq("png") }
    it { expect(Image.extension("foo.jpg    ")).to eq("jpg") }
  end
end
