class PropertytaxController < ApplicationController
  before_filter :choose_header
  
  def index
    @taxrates = {}
    (2011..2014).each do |year|
      @taxrates[year] = Propertytax.where(year: year)
    end
    
    render "index", layout: "top_bar"
  end
  
end