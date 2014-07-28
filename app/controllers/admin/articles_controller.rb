class Admin::ArticlesController < ApplicationController
  def new
    render layout: "admin"
  end

  def create
    article = Article.create!(params)
    redirect_to '/editor' + edit_admin_article_path(article.id)
  end
  
  def edit
    @article = Article.find(params[:id])
    
    render layout: 'admin_editor'
  end
  
  def update
    doc = params[:content]
    # {"content"=>{"title"=>{"type"=>"full", "data"=>{}, "value"=>"test3", "snippets"=>{}}, "content"=>{"type"=>"full", "data"=>{}, "value"=>"bb<p></p>", "snippets"=>{}}}
    @article = Article.find(params[:id])
    @article.update_attributes!(title: doc["title"]["value"], content: doc["content"]["value"])
    render json: {"result" => "everything is good"}
  end
  
  def index
    # check permission
    @articles = Article.all
    
    render layout: "admin"
  end
end