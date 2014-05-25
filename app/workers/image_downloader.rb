# Download images for a home
# ImageDownloader.new('71659343', 30, '5313a6c55740a841c9000002').download
class ImageDownloader
  def initialize(mls, photo_count, home_id)
    # http://media.mlspin.com/Photo.aspx?mls=71659343&n=4
    @mls = mls
    @count = photo_count
    @home_id = home_id
    @photo_dir = APP_CONFIG["image_dir"]
  end
  
  def download
    FileUtils::mkdir_p "#{@photo_dir}/#{@mls}"
    (0..@count-1).each do |index|
      File.open("#{@photo_dir}/#{@mls}/#{index}.jpg", "wb") do |f|
        f.write HTTParty.get("http://media.mlspin.com/Photo.aspx?mls=#{@mls}&n=#{index}").parsed_response
      end
    end
  end
end