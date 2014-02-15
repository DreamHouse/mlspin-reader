mlspin-reader
=============

Read MLSPIN data from web page

response = HTTParty.get('http://vow.mlspin.com/?cid=3146169&pass=')

doc = Nokogiri::HTML(response.body)

doc.css("td.VOWResultsHeading")[8].children.first.class
=> Nokogiri::XML::Text

doc.css("td.VOWResultsHeading")[8].children.first.text
=> "Status"

