class LandingController < ApplicationController
  def index
    if params["version"] == "2"
      render "version2"
    else
      render "index", layout: "top_bar"
    end
  end
  
  def search
    min_price = params[:min_price].to_i * 10000
    max_price = params[:max_price].to_i * 10000
    town = params[:town]
    bedroom_cnt = params[:bedroom_count].to_i
    restroom_cnt = params[:restroom_count].to_f

    home_query = Home.where(status: 'ACT').between(price: min_price..max_price).gte(bedrooms: bedroom_cnt).gte(bathrooms: restroom_cnt)
    
    unless town.blank?
      home_query = home_query.where(addr: /#{town}, MA/i)
    end
    
    
    @homes = home_query.asc(:price).paginate(:page => params[:page], :per_page => 30)
    render 'search_list', layout: "top_bar"
  end
end