tar zcvf app.tar.gz app/ db/ public/assets/towns public/assets/ads config/routes.rb Gemfile
scp app.tar.gz rails@ivygaterealty.com:/usr/local/website/mlspin-reader/
