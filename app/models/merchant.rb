class Merchant

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  
  field :name, type: String
  field :addr, type: String
  field :phone, type: String
  field :desc, type: String
  field :link, type: String
  has_mongoid_attached_file :photo
  
  validates_presence_of :name, :phone
  validates_uniqueness_of :name
  
  has_many :users
end