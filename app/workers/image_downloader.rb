# Download images for a home
# ImageDownloader.new('71659343', 30).download
class ImageDownloader
  def initialize(mls, photo_count)
    # http://media.mlspin.com/Photo.aspx?mls=71659343&n=4
    @mls = mls
    @count = photo_count
    @photo_dir = APP_CONFIG["image_dir"]
  end
  
  def download
    FileUtils::mkdir_p "#{@photo_dir}/#{@mls}"
    (0..@count-1).each do |index|
      file_name = "#{@photo_dir}/#{@mls}/#{index}.jpg"
      unless File.exists? file_name
        File.open(file_name, "wb") do |f|
          f.write HTTParty.get("http://media.mlspin.com/Photo.aspx?mls=#{@mls}&n=#{index}").parsed_response
        end
      end
    end
  end
end