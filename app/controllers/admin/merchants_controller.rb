class Admin::MerchantsController < ApplicationController
  layout "admin"
  
  def index
    # check permission
    @merchants = Merchant.unscoped.all
  end
  
  def new
  end
  
  def create
    merchant = Merchant.create!(params)
    
    # TODO: show a success or error message
    @merchants = Merchant.unscoped.all
    render 'index'
  end
  
end