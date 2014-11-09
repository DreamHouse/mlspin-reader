class PropertytaxController < ApplicationController
  before_filter :choose_header
  
  def index
    @taxrates = {}
    (2011..2014).each do |year|
      tax_array = Propertytax.where(year: year)
      tax_map_by_town = {}
      tax_array.each do |taxrate|
        tax_map_by_town[taxrate.town] = taxrate.rate
      end
      @taxrates[year] = tax_map_by_town
    end
    
    @top_50towns = Town.where(:hotness.gt => 2).map { |t| t.name }
    @top_20towns = Town.where(:hotness.gt => 3).map { |t| t.name }
    @all_towns = Town.all.map { |t| t.name }
    render "index", layout: "top_bar"
  end
  
end