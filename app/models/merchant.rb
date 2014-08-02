class Merchant

  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String
  field :addr, type: String
  field :phone, type: String
  field :desc, type: String
  field :photo, type: String
  field :link, type: String
  
  validates_presence_of :name, :phone
  validates_uniqueness_of :name
  
  has_many :users
end