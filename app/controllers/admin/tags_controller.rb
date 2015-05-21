class Admin::TagsController < ApplicationController  
  layout "admin"
  
  def index
    if params[:v] == '1'
      @tags = Tag.where(vocabulary: '维护房产')
    else
      @tags = Tag.all
    end
  end
  
end