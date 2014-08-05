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
