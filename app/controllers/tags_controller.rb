class TagsController < ApplicationController  
  def index
    if params[:level]
      @tags = Tag.where(level: params[:level].to_i)
    else
      @tags = Tag.all
    end
  end
  
  # show some articles for one tag
  def show
    
  end
end