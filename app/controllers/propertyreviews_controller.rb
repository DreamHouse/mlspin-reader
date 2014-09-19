class PropertyreviewsController < ApplicationController  
  before_filter :authenticate_user!, only: [:new, :create]
  
  layout "top_bar"
  
  def index
    @propertyreviews = Propertyreview.all
  end
  
  def new
  end
  
  def create
  end
  
  def show
  end
end