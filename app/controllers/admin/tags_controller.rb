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
  end
  
  def new
    if params[:v] == '1'
      @tags = Tag.where(vocabulary: '维护房产').where(level: 1)
    else
      @tags = Tag.all.where(level: 1)
    end
  end
  
  def create
    if params[:parent]
      parent = Tag.where(id: params[:parent]).first
      @new_tag = parent.add_child(params[:name], desc: params[:desc])
    else
      @new_tag = Tag.new(name: params[:name], desc: params[:desc])
    end
    if @new_tag.valid?
      @new_tag.save!
    else
      @error = @new_tag.errors.full_messages
    end
  end
  
  def destroy
    Rails.logger.debug "delete tag #{params[:id]}"
    Tag.find(params[:id]).delete
    redirect_to action: "index"
  end
end