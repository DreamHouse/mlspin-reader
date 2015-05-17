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
    tag = Tag.where(id: params[:id]).first
    if tag
      @articles = Article.where(published: nil).where(:tag_ids.in => [tag.id])
    else
      @error = :no_data
    end
    
    render layout: "simple"
  end
end