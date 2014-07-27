class Admin::ArticlesController < ApplicationController
  def new
    render layout: "admin"
  end

  def index
    # check permission
    @articles = Article.all
    
    render layout: "admin"
  end
end