class Image
  DATA_DIRECTORY = ENV.fetch("DATA_DIRECTORY", "./data/")

  def self.all
    image_names = Dir.glob("#{DATA_DIRECTORY}/*.{jpg,png}")
    image_names.map do |image|
      {
        filename: File.basename(image),
        content: "data:image/#{extension(image)};base64,#{base64(image)}",
      }
    end
  end

  def self.base64(image)
    Base64.encode64(File.open(image).read)
  end

  def self.extension(image)
    File.extname(image).strip.downcase[1..-1]
  end
end
