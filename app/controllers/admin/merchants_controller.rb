class Admin::MerchantsController < ApplicationController
  layout "admin"
  
  def index
    # check permission
    @merchants = Merchant.unscoped.all
  end
  
  def new
  end
  
  def create
    @merchant = Merchant.create!(params)
  end
  
  def show
    @merchant = Merchant.unscoped.find(params[:id])
  end
  
  def edit
    @merchant = Merchant.unscoped.find(params[:id])
  end
  
  def update_photo
    @merchant = Merchant.unscoped.find(params[:id])
    @merchant.update_attributes!(params[:merchant])
    render "show"
  end
  
  def update
    doc = params[:content]
    # {"content"=>{"title"=>{"type"=>"full", "data"=>{}, "value"=>"test3", "snippets"=>{}}, "content"=>{"type"=>"full", "data"=>{}, "value"=>"bb<p></p>", "snippets"=>{}}}
    @merchant = Merchant.unscoped.find(params[:id])
    @merchant.update_attributes!(name: doc["name"]["value"], desc: doc["desc"]["value"], phone: doc["phone"]["value"], addr: doc["addr"]["value"], link: doc["link"]["value"])
    render json: {"result" => "everything is good"}
  end
  
  def publish
    @merchant = Merchant.unscoped.find(params[:id])
    if @merchant
      @merchant.published = params[:publish]
      @merchant.save!
    end
  end
  
end