class Image
  DATA_DIRECTORY = ENV.fetch("DATA_DIRECTORY", "./data/")

  def self.all
    image_names = Dir.glob("#{DATA_DIRECTORY}/*").map { |file| File.basename(file) }
    image_names.map do |image_name|
      { filename: image_name }
    end
  end
end
