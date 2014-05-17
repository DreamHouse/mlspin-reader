class LandingController < ApplicationController
  def index
    if params["version"] == "2"
      render "version2"
    else
      render "index"
    end
  end
  
  def search
    min_price = params[:min_price].to_i * 10000
    max_price = params[:max_price].to_i * 10000
    town = params[:town]
    
    Rails.logger.info "min price: #{min_price}"
    @homes = Home.between(price: min_price..max_price)
    render 'search_list'
  end
end