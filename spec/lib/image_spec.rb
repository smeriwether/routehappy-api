require "spec_helper"

RSpec.describe Image do
  it { expect(Image).to respond_to(:all) }

  it "can be initialized" do
    expect(Image.new(filename: "", data: "")).to be_a(Image)
  end

  describe "#save" do
    it "can save an image to the data directory" do
      image = unique_image_from_datafiles
      data = File.open(image)

      saved = Image.new(filename: File.basename(image), data: data).save

      expect(saved).to eq(true)
      expect(data_exist?(image)).to eq(true)
    end

    it "can save 2 images with the same name" do
      image_name = add_image_to_disk!
      data = File.open("#{IMAGES_DIRECTORY}/#{image_name}")

      saved = Image.new(filename: File.basename(image_name), data: data).save

      expect(saved).to eq(true)
      expect(data_files.size).to eq(2)
    end

    it "doesn't save if there isn't a filename" do
      expect(Image.new(filename: nil, data: "").save).to be_falsey
    end

    it "doesn't save if there isn't data" do
      expect(Image.new(filename: "", data: nil).save).to be_falsey
    end

    it "doesn't raise an error if the file isn't readable/found" do
      expect(Image.new(filename: "", data: "").save).to be_falsey
    end

    it "doesn't save anything but jpg, png & jpeg" do
      image = "#{IMAGES_DIRECTORY}/not-image.txt"
      data = File.open(image)

      saved = Image.new(filename: File.basename(image), data: data).save

      expect(saved).to be_falsey
      expect(data_exist?(image)).to eq(false)
    end

    it "doesn't save images smaller than 350x350" do
      image = "#{BAD_IMAGES_DIRECTORY}/too-small.jpg"
      data = File.open(image)

      saved = Image.new(filename: File.basename(image), data: data).save

      expect(saved).to be_falsey
      expect(data_exist?(image)).to eq(false)
    end

    it "doesn't save images larger than 5000x5000" do
      image = "#{BAD_IMAGES_DIRECTORY}/too-big.jpg"
      data = File.open(image)

      saved = Image.new(filename: File.basename(image), data: data).save

      expect(saved).to be_falsey
      expect(data_exist?(image)).to eq(false)
    end
  end

  describe "#errors" do
    it "returns nil when there are no errors" do
      image = unique_image_from_datafiles
      data = File.open(image)

      image = Image.new(filename: File.basename(image), data: data)
      image.save
      errors = image.errors

      expect(errors).to be_nil
    end

    it "doesn't return nil when the record is invalid" do
      image = unique_image_from_datafiles

      image = Image.new(filename: File.basename(image), data: nil)
      image.save
      errors = image.errors

      expect(errors).not_to be_nil
    end

    it "doesn't return nil when there was an exception thrown" do
      image = Image.new(filename: "fake-image.jpg", data: "")
      image.save
      errors = image.errors

      expect(errors).not_to be_nil
    end
  end

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
