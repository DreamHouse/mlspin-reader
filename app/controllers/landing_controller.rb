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
    bedroom_cnt = params[:bedroom_count]
    restroom_cnt = params[:restroom_count]

    home_query = Home.where(status: 'ACT').between(price: min_price..max_price).asc(:price)
    
    unless town.blank?
      home_query = home_query.where(addr: /#{town}, MA/i)
    end
    
    
    @homes = home_query.paginate(:page => params[:page], :per_page => 30)
    render 'search_list', layout: "top_bar"
  end
end