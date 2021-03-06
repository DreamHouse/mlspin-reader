# encoding: utf-8

# Read details from a page and persist the details in Home collection
# The home document must exist in database before using this parser.
# 
# parser = HomeParser.new("9 Keeler Farm Lexington, MA", 'http://vow.mlspin.com/clients/report.aspx?thisnum=2&mls=71659343&cid=3146169&pass=paul')
# parser.get_page_details
# 
# For testing, 
# parser = HomeParser.new("1 Peartree Drive Lexington, MA", '', '').get_page_details
class HomeParser
  include StringHelper
  def initialize(addr, link, cookie)
    @addr = addr
    @link = link
    @cookie = cookie
  end
  
  def get_page_details
    # content = File.read("spec/fixtures/new_house.html")
    response = HTTParty.get(@link, headers: {'Cookie' => @cookie } )
    content = response.body
    
    Rails.logger.debug "Parse details for addr #{@addr}"
    get_details(content)
    
    Rails.logger.debug "Download images for addr #{@addr}"
    # download_image
  end
  
  def download_image
    home = Home.find_by(addr: @addr)
    if home[:mls] && home[:photo_count]
      ImageDownloader.new(home[:mls], home[:photo_count]).download
    end
  end
  
  def get_details(content)
    home = Home.find_by(addr: @addr)
    doc = Nokogiri::HTML(content)
    
    # Parse Remarks
    remark_table = nil
    # doc.css('html>body>center>table>tbody>tr>td>table>tbody>tr>td>table').each do |table|
    doc.css('html>body>center>table>tr>td>table>tr>td>table').each do |table|
      if table.text && table.text.strip == 'Remarks'
        remark_table = table
      end
    end
    
    if remark_table && remark_table.next
      home[:remarks] = sanitize_str(remark_table.next.text)
    end
    
    # Parse Room details
    table_node = nil
    # doc.css('html>body>center>table>tbody>tr>td>table>tbody>tr>td>table>tbody>tr').each do |element|
    doc.css('html>body>center>table>tr>td>table>tr>td>table>tr').each do |element|
      if element.children.size >= 6 && element.children[0].text && element.children[0].text.strip == 'Room' \
        && element.children[2].text && element.children[2].text.strip == 'Level'
        table_node = element.parent
      end
    end  

    rooms = []
    if table_node
      (1..table_node.children.size-1).each do |i|
        room_name = sanitize_str(table_node.children[i].children[0].text).gsub(/:$/, '')
        level = sanitize_str(table_node.children[i].children[2].text)
        size = sanitize_str(table_node.children[i].children[4].text)
        features = sanitize_str(table_node.children[i].children[6].text)
        rooms << { name: room_name, level: level, size: size, features: features }
      end
    end
    home[:room_details] = rooms
    
    # Parse Property Information section
    # doc.css('html>body>center>table>tbody>tr>td>table>tbody>tr>td>table>tbody>tr>td').each do |element|
    doc.css('html>body>center>table>tr>td>table>tr>td>table>tr>td').each do |element|
      if element.children[0].name == "text" && element.children[0].text && element.children[0].text.strip.end_with?(":")
        if element.children.size>1 && element.children[1].name == "b"
          case element.text
          when /Approx. Living Area:/
            update_attribute(home, 'Approx. Living Area', element)
          when /Approx. Acres:/
            update_attribute(home, 'Approx. Acres', element)
          when /Garage Spaces:/
            update_attribute(home, 'Garage Spaces', element)
          when /Living Area Includes:/
            update_attribute(home, 'Living Area Includes', element)
          when /Heat Zones:/
            update_attribute(home, 'Heat Zones', element)
          when /Parking Spaces:/
            update_attribute(home, 'Parking Spaces', element)
          when /Living Area Source:/
            update_attribute(home, 'Living Area Source', element)
          when /Cool Zones:/
            update_attribute(home, 'Cool Zones', element)
          when /Approx. Street Frontage:/
            update_attribute(home, 'Approx. Street Frontage', element)
          when /Living Area Disclosures:/
            update_attribute(home, 'Living Area Disclosures', element)
          when /Disclosures:/
            update_attribute(home, 'Disclosures', element)          
          end
        end
      end
    end  

    # Parse the number of pictures
    photo_elements = doc.css('html>body>center>table>tr>td>table>tr>td>table>tr>td>table>tr.noprint>td.h>strong')
    if photo_elements.count > 0
      photo_count = photo_elements[0].text.to_i # "\r\n 30\r\n  Photos"
      home[:photo_count] = photo_count
    end
    
    # Parse Basic, Features, Other Property Info
    # doc.css('html>body>center>table>tbody>tr>td>table>tbody>tr>td>table>tbody>tr>td>table>tbody>tr>td').each do |element|
    doc.css('html>body>center>table>tr>td>table>tr>td>table>tr>td>table>tr>td').each do |element|
      case element.text
      when /Style:/
        update_attribute(home, 'Style', element)
      when /Total Rooms:/
        update_attribute(home, 'Total Rooms', element)
      when /Bedrooms:/
        home[:bedrooms] = sanitize_str(element.text.gsub("Bedrooms:", '')).to_i
      when /Bathrooms:/
        bathrooms = sanitize_str(element.text.gsub("Bathrooms:", ''))
        if bathrooms.is_a? String
          bathrooms_regex = bathrooms.match(/(.*f)(.*h)/)
          if bathrooms_regex.size >= 3
            home[:bathrooms] = bathrooms_regex[1].to_i + bathrooms_regex[2].to_i * 0.5
          end
        end
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
        entries = element.text.match(/(UFFI)(.*)(Warranty Features)(.*)/m)
        if entries.size == 5
          home["uffi".to_sym] = sanitize_str(entries[2].gsub(":", ''))
          home["warranty_features".to_sym] = sanitize_str(entries[4].gsub(":", ''))
        end
      when /Year Built:/
        entries = element.text.match(/(Year Built)(.*)(Source)(.*)/m)
        if entries.size == 5
          home["year_built".to_sym] = sanitize_str(entries[2].gsub(":", ''))
          home["source".to_sym] = sanitize_str(entries[4].gsub(":", ''))
        end
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
        entries = element.text.match(/(Tax)(.*)(Tax Year)(.*)/m)
        if entries.size == 5
          home["tax".to_sym] = sanitize_str(entries[2].gsub(":", ''))
          home["tax_year".to_sym] = sanitize_str(entries[4].gsub(":", ''))
        end
      when /Book:/
        entries = element.text.match(/(Book)(.*)(Page)(.*)/m)
        if entries.size == 5
          home["book".to_sym] = sanitize_str(entries[2].gsub(":", ''))
          home["page".to_sym] = sanitize_str(entries[4].gsub(":", ''))
        end
      when /Page:/
        update_attribute(home, 'Page', element)
      when /Cert:/
        update_attribute(home, 'Cert', element)
      when /Zoning Code:/
        update_attribute(home, 'Zoning Code', element)
      when /Map:/
        # "Map: \n Block: \n Lot:".match(/(Map)(.*)(Block)(.*)(Lot)(.*)/m)
        map_entries = element.text.match(/(Map)(.*)(Block)(.*)(Lot)(.*)/m)
        if map_entries.size == 7
          home["map".to_sym] = sanitize_str(map_entries[2].gsub(":", ''))
          home["block".to_sym] = sanitize_str(map_entries[4].gsub(":", ''))
          home["lot".to_sym] = sanitize_str(map_entries[6].gsub(":", ''))
        end
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
end