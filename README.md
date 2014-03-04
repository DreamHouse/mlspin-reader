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

Style: 
    Colonial


Total Rooms: 
    12


Color: 
    


Bedrooms: 
    5


Grade School: 
    Fiske


Bathrooms: 
    5f 1h


Middle School: 
    Diamond


Master Bath: 
    Yes


High School: 
    Lexington


Fireplaces: 
    1


Handicap Access/Features:
    --




Directions: 
    South side of East Street between Grant Street and Adams Street.




Features




Appliances: 
    Wall Oven, Dishwasher, Disposal, Microwave, Countertop Range, Refrigerator, Vacuum System, Vent Hood


Area Amenities: 
    Public Transportation, Shopping, Walk/Jog Trails, Bike Path, Conservation Area, Highway Access, Private School, Public School


Basement: 
    Yes   Full, Partially Finished, Interior Access, Bulkhead



Beach: 
    No



Construction: 
    Frame


Electric: 
    200 Amps


Energy Features: 
    Insulated Windows, Prog. Thermostat


Exterior: 
    Clapboard


Exterior Features: 
    Porch, Deck, Gutters, Professional Landscaping, Sprinkler System, Decorative Lighting, Screens


Flooring: 
    Tile, Hardwood, Stone / Slate


Foundation Size: 
    Irregular


Foundation Description: 
    Poured Concrete


Hot Water: 
    Natural Gas, Tank


Insulation: 
    Full


Interior Features: 
    Central Vacuum, Security System, Cable Available, Walk-up Attic, French Doors


Lot Description: 
    Paved Drive, Level


Road Type: 
    Private, Paved, Privately Maint., Cul-De-Sac


Roof Material: 
    Asphalt/Fiberglass Shingles


Sewer Utilities: 
    City/Town Sewer
    
    



Utility Connections: 
    for Gas Range, for Gas Oven, for Electric Dryer, Washer Hookup, Icemaker Connection


Water Utilities: 
    City/Town Water


Waterfront: 
    No



Water View: 
    No





Other Property Info




Adult Community: 
    No


Disclosure Declaration: 
    No


Exclusions: 
    


Facing Direction: 
            East
        


Home Own Assn: 
    No



Lead Paint: 
    None


UFFI: 
    No  Warranty Features: 
        --


Year Built: 
    2014  Source: 
        Builder


Year Built Description: 
    Actual, Under Construction


Year Round: 
    --


Short Sale w/Lndr.App.Req: No


Lender Owned: No




Tax Information




Pin #: 
    


Assessed: $999,999,999


Tax: $99999999.00  Tax Year: 
    2014


Book: 
    999999  Page: 
        9999


Cert: 
    


Zoning Code: 
    Res


Map: 
      Block: 
          Lot: 
