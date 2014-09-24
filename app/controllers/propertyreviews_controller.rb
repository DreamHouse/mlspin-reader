class PropertyreviewsController < ApplicationController  
  before_filter :authenticate_user!, only: [:new, :create]
  
  layout "top_bar"
  
  def index
    @propertyreviews = Propertyreview.all
  end
  
  def new
    @server_url = "#{request.protocol}#{request.host}:#{request.port}"
  end
  
  def create
  end
  
  def show
    @home = Home.find(params[:id])
  end
end