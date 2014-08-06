class MerchantsController < ApplicationController  
  layout "top_bar"
  
  def index
    @merchants = Merchant.where(tags: params[:tag])
  end
  
  def show
    @merchant = Merchant.where(id: params[:id]).first
  end
end