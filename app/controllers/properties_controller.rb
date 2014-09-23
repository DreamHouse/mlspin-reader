class PropertiesController < ApplicationController
  def show
    mls = params[:id]
    addr = params[:addr]
    
    if addr
      town = params[:town]
      if town
        addr = addr + " " + town
      end
      @home = Home.where(addr: /#{addr}/i).first
    elsif mls
      @home = Home.where(mls: mls).first
    end
    
    respond_to do |format|
      format.html {render layout: "top_bar"}
      format.json {
        if @home
          render :json => @home
        else
          render :status => 404, :json => {error: "property not found"}
        end
      }
    end
  end
end