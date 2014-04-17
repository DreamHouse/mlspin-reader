class LandingController < ApplicationController
  def index
    if params["version"] == "2"
      render "version2"
    else
      render "index"
    end
  end
end