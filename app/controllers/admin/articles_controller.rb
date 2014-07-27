class Admin::ArticlesController < ApplicationController

  def index
    # check permission
    @articles = Article.all
    
    render layout: "admin"
  end
end