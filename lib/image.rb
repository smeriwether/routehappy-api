require "dimensions"
require "base64"

class Image
  VALID_TYPES = %w(jpg jpeg png).freeze

  def initialize(filename:, data:)
    @filename = filename
    @data = data
    @errors = nil
  end

  def save
    if valid?
      write_to_disk!
    else
      @errors = "Invalid Image"
      false
    end
  rescue => e
    @errors = e.message
    nil
  end

  def errors
    @errors
  end

  def self.all
    image_names = Dir.glob("#{DATA_DIRECTORY}/*.{#{VALID_TYPES.join(',')}}")
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
    width = Dimensions.width(@data.path)
    height = Dimensions.height(@data.path)
    !@filename.nil? &&
      !@data.nil? &&
      VALID_TYPES.include?(Image.extension(@filename)) &&
      width >= 350 && width <= 5000 &&
      height >= 350 && height <= 5000
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
