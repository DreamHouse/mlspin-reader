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

  # get_details("9 Keeler Farm Lexington, MA", content)  
  def get_page_details(addr, link)
    # TODO: read content from link
    content = File.read("spec/fixtures/one_house.html")
    get_details(addr, content)
  end
  
  def get_details(addr, content)
    home = Home.find_by(addr: addr)
    doc = Nokogiri::HTML(content)
    doc.css('html body center table tbody tr td table tbody tr td table tbody tr td table tbody tr td').each do |element|
      case element.text
      when /Style:/
        update_attribute(home, 'Style', element)
      when /Total Rooms:/
        update_attribute(home, 'Total Rooms', element)
      when /Bedrooms:/
        update_attribute(home, 'Bedrooms', element)
      when /Bathrooms:/
        update_attribute(home, 'Bathrooms', element)
      when /Master Bath:/
        update_attribute(home, 'Master Bath', element)
      when /Fireplaces:/
        update_attribute(home, 'Fireplaces', element)
      when /Color:/
        update_attribute(home, 'Color', element)
      when /Grade School:/
        update_attribute(home, 'Grade School', element)
      when /Middle School:/
        update_attribute(home, 'Middle School', element)
      when /High School:/
        update_attribute(home, 'High School', element)
      when /Directions:/
        update_attribute(home, 'Directions', element)
        
      ###### FEATURES #########
      when /Appliances:/
        update_attribute(home, 'Appliances', element)
      when /Area Amenities:/
        update_attribute(home, 'Area Amenities', element)
      when /Basement:/
        update_attribute(home, 'Basement', element)
      when /Beach:/
        update_attribute(home, 'Beach', element)
      when /Construction:/
        update_attribute(home, 'Construction', element)
      when /Electric:/
        update_attribute(home, 'Electric', element)
      when /Energy Features:/
        update_attribute(home, 'Energy Features', element)
      when /Exterior:/
        update_attribute(home, 'Exterior', element)
      when /Exterior Features:/
        update_attribute(home, 'Exterior Features', element)
      when /Flooring:/
        update_attribute(home, 'Flooring', element)
      when /Foundation Size:/
        update_attribute(home, 'Foundation Size', element)
      when /Foundation Description:/
        update_attribute(home, 'Foundation Description', element)
      when /Hot Water:/
        update_attribute(home, 'Hot Water', element)
      when /Insulation:/
        update_attribute(home, 'Insulation', element)
      when /Interior Features:/
        update_attribute(home, 'Interior Features', element)
      when /Lot Description:/
        update_attribute(home, 'Lot Description', element)
      when /Road Type:/
        update_attribute(home, 'Road Type', element)
      when /Roof Material:/
        update_attribute(home, 'Roof Material', element)
      when /Sewer Utilities:/
        update_attribute(home, 'Sewer Utilities', element)
      when /Utility Connections:/
        update_attribute(home, 'Utility Connections', element)
      when /Water Utilities:/
        update_attribute(home, 'Water Utilities', element)
      when /Waterfront:/
        update_attribute(home, 'Waterfront', element)
      when /Water View:/
        update_attribute(home, 'Water View', element)
      
      ####### Other Property Info ###########
      when /Adult Community:/
        update_attribute(home, 'Adult Community', element)
      when /Disclosure Declaration:/
        update_attribute(home, 'Disclosure Declaration', element)
      when /Exclusions:/
        update_attribute(home, 'Exclusions', element)
      when /Facing Direction:/
        update_attribute(home, 'Facing Direction', element)
      when /Home Own Assn:/
        update_attribute(home, 'Home Own Assn', element)
      when /Lead Paint:/
        update_attribute(home, 'Lead Paint', element)
      when /UFFI:/
        update_attribute(home, 'UFFI', element)
      when /Warranty Features:/
        update_attribute(home, 'Warranty Features', element)
      when /Year Built:/
        update_attribute(home, 'Year Built', element)
      when /Source:/
        update_attribute(home, 'Source', element)
      when /Year Built Description:/
        update_attribute(home, 'Year Built Description', element)
      when /Year Round:/
        update_attribute(home, 'Year Round', element)
      when /Short Sale w\/Lndr.App.Req:/
        update_attribute(home, 'Short Sale w/Lndr.App.Req', element)
      when /Lender Owned:/
        update_attribute(home, 'Water View', element)
      when /Pin:/
        update_attribute(home, 'Pin', element)
      when /Assessed:/
        update_attribute(home, 'Assessed', element)
      
      ####### Tax ###########
      when /Tax:/
        update_attribute(home, 'Tax', element)
      when /Tax Year:/
        update_attribute(home, 'Tax Year', element)
      when /Book:/
        update_attribute(home, 'Book', element)
      when /Page:/
        update_attribute(home, 'Page', element)
      when /Cert:/
        update_attribute(home, 'Cert', element)
      when /Zoning Code:/
        update_attribute(home, 'Zoning Code', element)
      when /Map:/
        # "Map: \n Block: \n Lot:".match(/(Map)(.*)(Block)(.*)(Lot)(.*)/m)
        # "Map: \n Block: \n Lot:"
        # 1:"Map"
        #         2:": \n "
        #         3:"Block"
        #         4:": \n "
        #         5:"Lot"
        #         6:":"
        update_attribute(home, 'Map', element)
      end
    end
    home.save!
  rescue => e
    Rails.logger.error "Failed to update home due to #{e.message}"
    Rails.logger.debug e.backtrace
  end
  
protected
  def update_attribute(home, name, element)
    home[name.downcase.gsub(/[\s\.\/]+/, "_").to_sym] = sanitize_str(element.text.gsub("#{name}:", ''))
  end
  
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
