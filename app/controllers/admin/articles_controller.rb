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
    article = Article.create!(params)
    redirect_to '/editor' + edit_admin_article_path(article.id)
  end
  
  def edit
    @article = Article.unscoped.find(params[:id])
    
    render layout: 'admin_editor'
  end
  
  def update
    doc = params[:content]
    # {"content"=>{"title"=>{"type"=>"full", "data"=>{}, "value"=>"test3", "snippets"=>{}}, "content"=>{"type"=>"full", "data"=>{}, "value"=>"bb<p></p>", "snippets"=>{}}}
    @article = Article.unscoped.find(params[:id])
    @article.update_attributes!(title: doc["title"]["value"], content: doc["content"]["value"], desc: doc["desc"]["value"])
    render json: {"result" => "everything is good"}
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