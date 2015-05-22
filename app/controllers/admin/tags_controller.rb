class Admin::TagsController < ApplicationController  
  layout "admin"
  
  def index
    if params[:v] == '1'
      tags = Tag.where(vocabulary: '维护房产').where(level: 1)
    else
      tags = Tag.all.where(level: 1)
    end
    
    @tags = tags.to_a.each do |tag|
      tag.children = Tag.where(parent: tag).to_a
    end
    
    @tags.each do |tag| 
      Rails.logger.debug tag.children.count
    end
  end
  
end