class Admin::MerchantsController < ApplicationController
  layout "admin"
  
  def index
    # check permission
    @merchants = Merchant.unscoped.all
  end
end