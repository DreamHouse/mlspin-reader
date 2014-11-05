class Propertytax

  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :town, type: String
  field :state, type: String
  field :year, type: Integer
  field :rate, type: Float
end