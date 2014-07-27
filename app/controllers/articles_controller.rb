class ArticlesController < ApplicationController
  def new
    
  end
  
  def show
    mls = params[:id]
    @article = Article.where(id: params[:id]).first
    
    render layout: "top_bar"
  end
end