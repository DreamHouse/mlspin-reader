# encoding: utf-8

class MlspinCrawler
  include StringHelper
  
  def get_listing
    get_first_page
    (2..@page_count).each { |page_index| get_one_page(page_index) }
  end
  
protected
  def upsert(status, size, price, addr, date, time, link, mls, fetch_if_exists = false)
    if Home.where(addr: addr).count > 0
      Rails.logger.debug "Home #{addr} already exists"
      home = Home.find_by(addr: addr)
      home.update_attributes(status: status, desc: size, price: price.delete("$,").to_i, addr: addr, received: Time.parse("#{date} #{time}"), link: link, mls: mls)
      
      if link && fetch_if_exists
        HomeParser.new(addr, "http://vow.mlspin.com/clients/#{link}", @cookie).get_page_details
        sleep 2
      end
    else
      Home.create!(status: status, desc: size, price: price.delete("$,").to_i, addr: addr, received: Time.parse("#{date} #{time}"), link: link, mls: mls)
      if link
        HomeParser.new(addr, "http://vow.mlspin.com/clients/#{link}", @cookie).get_page_details
        sleep 2
      end
    end
  rescue => e
    Rails.logger.error "Failed to upsert home for #{addr} due to #{e.message}, #{e.backtrace}"
  end
  
  def get_first_page
    @page_count = 0 # reset @page_count
    response = HTTParty.get("http://vow.mlspin.com/?cid=3146169&pass=#{APP_CONFIG['mlspin_pass']}")
    response_body = response.body
    @cookie = response.request.options[:headers]['Cookie']
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
        # http://vow.mlspin.com/clients/report.aspx?thisnum=1&mls=71658069
        link_params = CGI.parse(URI.parse(link).query)
        if link_params["mls"].count > 0
          mls = link_params["mls"][0]
        end
      end
      addr = sanitize_str(table_node.children[i].children[11 + offset].text)
      size = sanitize_str(table_node.children[i].children[15 + offset].text)
      price = sanitize_str(table_node.children[i].children[19 + offset].text)
      date = sanitize_str(table_node.children[i].children[23 + offset].text)
      time = sanitize_str(table_node.children[i].children[25 + offset].text)
      
      upsert(status, size, price, addr, date, time, link, mls, false)
    end
  end
end
