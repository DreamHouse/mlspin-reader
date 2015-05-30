class Admin::ArticlesController < ApplicationController
  layout "admin"
  
  def index
    # check permission
    @articles = Article.unscoped.all
  end
  
  
  def new
    prepare_tags
  end

  def create
    article = Article.create!(title: params[:title], desc: params[:desc][0], source_link: params[:source_link],
      publish_date: params[:publish_date], author: params[:author], content: params[:content][0])
    params[:tags].each do |tag_id|
      tag = Tag.where(id: tag_id).first
      if tag
        article.tags << tag
      end
    end
    redirect_to admin_articles_path
  end
  
  def edit
    prepare_tags
    @article = Article.unscoped.find(params[:id])
  end
  
  def update
    @article = Article.unscoped.find(params[:id])
    @article.update_attributes!(title: params[:title], desc: params[:desc][0], content: params[:content][0])
    if params[:tags]
      @article.tags = []
      params[:tags].each do |tag_id|
        tag = Tag.where(id: tag_id).first
        if tag
          @article.tags << tag
        end
      end
    end
    redirect_to admin_articles_path
  end
  
  def publish
    @article = Article.unscoped.find(params[:id])
    if @article
      @article.published = true
      @article.save!
    end
  end
  
  def destroy
    Article.find(params[:id]).delete
    redirect_to action: "index"
  end
  
  protected
  def prepare_tags
    tags = Tag.all.where(level: 1)
    @tags = []
    tags.to_a.each do |tag|
      @tags << tag
      @tags.push(*Tag.where(parent: tag).to_a)
    end
    @tag_count = Tag.count
  end
end