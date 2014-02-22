class MlspinCrawler
  def sanitize_str(str)
    # replace &nbsp; with space
    str.gsub("\xC2\xA0", " ").strip
  end
  
  def upsert(status, size, price, addr, date, time)
    if Home.where(addr: addr).count > 0
      Rails.logger.debug "Home #{addr} already exists"
      # update status only?
    else
      Home.create!(status: status, desc: size, price: price.delete("$,").to_i, addr: addr, received: Time.parse("#{date} #{time}"))
    end
  end
  
  def get_listing
    # response = HTTParty.get("http://vow.mlspin.com/?cid=3146169&pass=#{APP_CONFIG['mlspin_pass']}").body
    response = File.read("spec/fixtures/mlspin.html") # read from local disk
    doc = Nokogiri::HTML(response)
    
    table_headers = doc.css("td.VOWResultsHeading")
    status_node = table_headers.select { |element| element.children.first.text == 'Status' }
    table_node = status_node[0].parent.parent


    (1..table_node.children.count-1).each do |i| 
      status = sanitize_str(table_node.children[i].children[8].text)
      offset = 0
      if status == "Off Market"
        offset = 1
      end
      addr = sanitize_str(table_node.children[i].children[11 + offset].text)
      size = sanitize_str(table_node.children[i].children[15 + offset].text)
      price = sanitize_str(table_node.children[i].children[19 + offset].text)
      date = sanitize_str(table_node.children[i].children[23 + offset].text)
      time = sanitize_str(table_node.children[i].children[25 + offset].text)
      
      upsert(status, size, price, addr, date, time)
    end
  end
end