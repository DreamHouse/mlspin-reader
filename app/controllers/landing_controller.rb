class LandingController < ApplicationController
  def index
    if params["version"]
      render "version#{params["version"]}"
    else
      render "index"
    end
  end
end