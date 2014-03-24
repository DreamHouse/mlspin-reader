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
table_node = nil
doc.css('html>body>center>table>tbody>tr>td>table>tbody>tr>td>table>tbody>tr').each do |element|
  if element.children.size >= 6 && element.children[0].text.strip == 'Room' && element.children[2].text.strip == 'Level'
    table_node = element.parent
  end
end  
room = table_node.children[1].children[0].text
level = table_node.children[1].children[2].text
size = table_node.children[1].children[4].text
features = table_node.children[1].children[6].text
