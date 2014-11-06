class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def choose_header
    @header_version = (params["header_version"] || "")
  end
end
