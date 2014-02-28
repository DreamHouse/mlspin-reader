# encoding: utf-8

class MlspinCrawler
  def sanitize_str(str)
    # replace &nbsp; with space
    str.gsub("\xC2\xA0", " ").strip
  end
  
  def get_listing
    get_first_page
    (2..@page_count).each { |page_index| get_one_page(page_index) }
  end
  
protected
  def upsert(status, size, price, addr, date, time, link)
    if Home.where(addr: addr).count > 0
      Rails.logger.debug "Home #{addr} already exists"
      home = Home.find_by(addr: addr)
      home.update_attributes(status: status, desc: size, price: price.delete("$,").to_i, addr: addr, received: Time.parse("#{date} #{time}"), link: link)
    else
      Home.create!(status: status, desc: size, price: price.delete("$,").to_i, addr: addr, received: Time.parse("#{date} #{time}"), link: link)
    end
  rescue => e
    Rails.logger.error "Failed to upsert home for #{addr} due to #{e.message}"
  end
  
  def get_first_page
    @page_count = 0 # reset @page_count
    response = HTTParty.get("http://vow.mlspin.com/?cid=3146169&pass=#{APP_CONFIG['mlspin_pass']}")
    response_body = response.body
    @cookie = response.request.options[:headers]['Cookie']
    # page_2 = HTTParty.get('http://vow.mlspin.com/clients/index.aspx?p=2&s=100', headers: {'Cookie' => @cookie } )
    # response_body = File.read("spec/fixtures/mlspin.html") # read from local disk
    doc = Nokogiri::HTML(response_body)
    
    pager = doc.css("td.VOWResultsHeading select[name=p]")
    @page_count = pager.children.count
    Rails.logger.info "[#{Time.now}] [#{self.class} #{__method__}] Total #{@page_count} pages"
    
    process_page_listing(doc)
  end
  
  def get_one_page(index)
    Rails.logger.info "[#{Time.now}] [#{self.class} #{__method__}] Get page #{index}"
    response = HTTParty.get("http://vow.mlspin.com/clients/index.aspx?p=#{index}&s=100", headers: {'Cookie' => @cookie } )
    response_body = response.body
    process_page_listing(Nokogiri::HTML(response_body))
  end
  
  def process_page_listing(doc)
    table_headers = doc.css("td.VOWResultsHeading")
    status_node = table_headers.select { |element| element.children.first.text == 'Status' }
    table_node = status_node[0].parent.parent


    (1..table_node.children.count-1).each do |i| 
      status = sanitize_str(table_node.children[i].children[8].text)
      offset = 0
      if status == "Off Market"
        offset = 1
      else
        # link element is around address
        link = table_node.children[i].children[11].children[1].attr("href")
      end
      addr = sanitize_str(table_node.children[i].children[11 + offset].text)
      size = sanitize_str(table_node.children[i].children[15 + offset].text)
      price = sanitize_str(table_node.children[i].children[19 + offset].text)
      date = sanitize_str(table_node.children[i].children[23 + offset].text)
      time = sanitize_str(table_node.children[i].children[25 + offset].text)
      
      upsert(status, size, price, addr, date, time, link)
    end
  end
end