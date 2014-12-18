class BuyersController < ApplicationController  
  def show
    content = params[:id]
    render content, layout: "top_bar"
  end
end