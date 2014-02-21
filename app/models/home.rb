class Home

  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :status, type: String
  field :price, type: Integer
  field :address, type: String
  field :received, type: Time
  field :status, type: String
