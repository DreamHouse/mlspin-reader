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

After installing CKEditor gem, run:
rails generate ckeditor:install --orm=mongoid --backend=paperclip