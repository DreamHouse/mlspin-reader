class Home

  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :status, type: String
  field :price, type: Integer
  field :addr, type: String
  field :received, type: Time
  field :desc, type: String
  field :link, type: String
  
  has_many :propertyreviews
end