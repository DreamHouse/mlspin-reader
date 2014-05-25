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

    @homes = Home.between(price: min_price..max_price).paginate(:page => params[:page], :per_page => 30)
    render 'search_list', layout: "top_bar"
  end
end