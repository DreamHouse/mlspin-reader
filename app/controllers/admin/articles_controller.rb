class Admin::ArticlesController < ApplicationController
  def index
    # check permission
    @articles = Article.unscoped.all
    
    render layout: "admin"
  end
  
  def new
    render layout: "admin"
  end

  def create
    article = Article.create!(title: params[:title], desc: params[:desc][0], source_link: params[:source_link],
      publish_date: params[:publish_date], author: params[:author], content: params[:content][0])
    redirect_to admin_articles_path
  end
  
  def edit
    @article = Article.unscoped.find(params[:id])
    
    render layout: 'admin_editor'
  end
  
  def update
    @article = Article.unscoped.find(params[:id])
    @article.update_attributes!(title: params[:title], desc: params[:desc][0], content: params[:content][0])
    redirect_to admin_articles_path
  end
  
  def publish
    @article = Article.unscoped.find(params[:id])
    if @article
      @article.published = true
      @article.save!
    end
    
    render layout: 'admin_editor'
  end
end