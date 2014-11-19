class RatesController < ApplicationController  
  def index
    @rates = Rate.getRates({state: params[:state], program: params[:program]})
    render layout: "top_bar"
  end
  
  def historical
    @rates = Rate.where(state: 'MA', program: params[:program] || 'Fixed30Year').order_by(:sample_date.asc)
    
    lines = []
    lines.push ["date", "close"]
    @rates.collect { |rate| 
      lines.push ["#{rate.sample_date.strftime("%d-%b-%y")}", "#{rate.value}"]
    }
    
    lines = lines.collect {|line| line.join(',')}
    csv_string = lines.join("\n")
    respond_to do |format|
      format.html
      format.csv { send_data(csv_string, :filename => "historical.csv", :type => "text/csv") }
    end
  end
end