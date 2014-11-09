mlspin-reader
=============

Installation:
imagemagick is required to change image size by paperclip gem:
brew install imagemagick --with-libtiff

Setup roles: 
rails console
Role.create(type: 'admin')
Role.create(type: 'agent')
Role.create(type: 'partner')
Role.create(type: 'standard')

Tag.create(name: 'agent', value: '房产代理')
Tag.create(name: 'buyer-agent', value: '买方代理')
Tag.create(name: 'seller-agent', value: '卖方代理')
Tag.create(name: 'mortgage', value: '贷款')

Deployment 8/10/14
---------------
Tag.all.each do |tag|
  tag.usage = 'merchant'  
  tag.save!
end  

Tag.create(name: '房屋咨询', value: '房屋咨询', usage: 'question')
Tag.create(name: '社区', value: '社区', usage: 'question')
Tag.create(name: '贷款', value: '贷款', usage: 'question')
Tag.create(name: '维护', value: '维护', usage: 'question')

Grant user the admin role:
rails c
u = User.last
u.role = Role.first
u.save!

After installing CKEditor gem, run:
rails generate ckeditor:install --orm=mongoid --backend=paperclip

Deployment 11/7/2014
--------------------
Run db/tax_seed.db
In rails console

towns = []
Propertytax.where(year:2013).each do |pt|
  towns << pt.town  
end

towns.uniq!
towns.each do |town|
  Town.create!(name: town, state: 'MA')
end 

fifty_towns = []
Propertytax.where(year:2011).each do |pt|
  fifty_towns << pt.town
end  

Town.all.each do |town|
 if fifty_towns.include? town.name
   town.update_attributes(hotness: 3)
 end  
end  

Town.create!(name: 'Hyannis', hotness: 3, state: 'MA')
Run db/town_seed.rb


Deployment 11/8/2014
--------------------
Fix 2013 tax rate

year = '2011'
f = File.new("db/tax-#{year}.txt", 'r')
while(line = f.gets)
  matched = line.match(/([0-9]*)([a-zA-Z\s]*)([0-9.]*)/)
  if matched.size != 4
    puts "BAD LINE"
  else
    town_name = matched[2].strip
    pt = Propertytax.where(year: year).where(town: town_name).first
    if pt
      puts "Update #{town_name} rate to #{matched[3]}"
      pt.update_attributes(rate: matched[3].to_f)
    else
      puts "No town found for #{town_name}, adding it"
      Propertytax.create!(year: year, town: town_name, rate: matched[3].to_f)
    end
  end
end
f.close