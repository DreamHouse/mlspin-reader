tar zcvf app.tar.gz config/mongoid.yml app/ db/ public/fonts public/assets/towns public/assets/articles public/assets/ads config/routes.rb Gemfile
scp app.tar.gz rails@ivygaterealty.com:/usr/local/website/mlspin-reader/
