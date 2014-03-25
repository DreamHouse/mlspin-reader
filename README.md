mlspin-reader
=============

Read MLSPIN data from web page

# response = HTTParty.get('http://vow.mlspin.com/?cid=3146169&pass=')
response = File.read("spec/fixtures/mlspin.html") # read from local disk

doc = Nokogiri::HTML(response.body)

def update_attribute(home, name, element)
  home[name.downcase.gsub(/\s+/, "_").to_sym] = element.text.gsub("#{name}:", '').strip
end

home = Home.find_by(addr: "9 Keeler Farm Lexington, MA")
doc.css('html body center table tbody tr td table tbody tr td table tbody tr td table tbody tr td').each do |element|
  case element.text
  when /Style:/
    update_attribute(home, 'Style', element)
  when /Total Rooms:/
    update_attribute(home, 'Total Rooms', element)
  when /Color:/
    update_attribute(home, 'Color', element)
  end  
end  

=> "Colonial"

Works for a house and a condo

doc.css('html body center table tbody tr td table tbody tr td table tbody tr td table tbody tr td').each do |element|
  puts element.text
end

# parse Room Levels, Dimensions and Features
