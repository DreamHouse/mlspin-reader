class Admin::ArticlesController < ApplicationController
  layout "admin"
  
  def index
    # check permission
    @articles = Article.unscoped.all
  end
  
  def new
    tags = Tag.all.where(level: 1)
    @tags = []
    tags.to_a.each do |tag|
      @tags << tag
      @tags.push(*Tag.where(parent: tag).to_a)
    end
    @tag_count = Tag.count
  end

  def create
    article = Article.create!(title: params[:title], desc: params[:desc][0], source_link: params[:source_link],
      publish_date: params[:publish_date], author: params[:author], content: params[:content][0])
    redirect_to admin_articles_path
  end
  
  def edit
    @article = Article.unscoped.find(params[:id])
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
  end
end