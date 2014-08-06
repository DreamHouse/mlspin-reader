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