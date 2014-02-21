class MlspinCrawler
  def get_listing
    response = HTTParty.get("http://vow.mlspin.com/?cid=3146169&pass=#{APP_CONFIG['mlspin_pass']}")
    doc = Nokogiri::HTML(response.body)
    
    table_headers = doc.css("td.VOWResultsHeading")
    status_node = table_headers.select { |element| element.children.first.text == 'Status' }
    table_node = status_node[0].parent.parent


    (1..table_node.children.count-1).each do |i| 
      puts "status: " + table_node.children[i].children[8].text.strip
      offset = 0
      if table_node.children[i].children[8].text.strip == "Off Market"
        offset = 1
      end
      puts "addr: " + table_node.children[i].children[11 + offset].text.strip
      puts "size: " + table_node.children[i].children[15 + offset].text.strip
      puts "price: " + table_node.children[i].children[19 + offset].text.strip
      puts "date: " + table_node.children[i].children[23 + offset].text.strip
      puts "time: " + table_node.children[i].children[25 + offset].text.strip
    end
  end
end