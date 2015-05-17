class ArticlesController < ApplicationController  
  def show
    mls = params[:id]
    @article = Article.where(id: params[:id]).first
    
    render layout: "simple"
  end
end