class PropertiesController < ApplicationController
  def show
    mls = params[:id]
    @home = Home.where(mls: mls).first
    
    render layout: "top_bar"
  end
end