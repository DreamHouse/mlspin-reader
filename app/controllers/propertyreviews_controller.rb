class PropertyreviewsController < ApplicationController  
  before_filter :authenticate_user!, only: [:new, :create]
  
  layout "top_bar"
  
  def index
    @reviewed_homes = Propertyreview.all.reduce([]) do |result, pr| 
      result << pr.home 
    end
  end
  
  def new
    @server_url = "#{request.protocol}#{request.host}:#{request.port}"
  end
  
  def create
    @home = Home.find(params[:property_id])
    unless user_signed_in?
      @error = :no_user
    else
      @propertyreview = Propertyreview.create!(params)
      @propertyreview.content = params[:content][0]
      @propertyreview.home = @home
      @propertyreview.user = current_user
      @propertyreview.save!
    end
    # TODO: return json
    redirect_to propertyreview_path(@home.id)
  end
  
  def show
    @home = Home.find(params[:id])
    @propertyreviews = Propertyreview.where(home: @home.id)
  end
end