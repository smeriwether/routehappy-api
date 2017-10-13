class Image
  DATA_DIRECTORY = ENV.fetch("DATA_DIRECTORY", "./data/")

  def initialize(filename:, data:)
    @filename = filename
    @data = data
  end

  def save
    write_to_disk! if valid?
  rescue
    nil
  end

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

  private

  def valid?
    !@filename.nil? &&
      ["jpg", "png"].include?(Image.extension(@filename)) &&
      !@data.nil?
  end

  def write_to_disk!
    File.open("#{DATA_DIRECTORY}/#{unique_identifier}-#{@filename}", "wb") do |file|
      file.write(@data.read)
    end
    true
  end

  def unique_identifier
    Time.now.to_i
  end
end
