class Merchant

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  
  field :name, type: String
  field :addr, type: String
  field :phone, type: String
  field :desc, type: String
  field :link, type: String
  field :published, type: Boolean
  field :tags, type: Array
  
  has_mongoid_attached_file :photo
  # , :styles => { :thumb => ["50x50#", :png], :small => ["100x100#", :png], :medium => ["150x150>", :png] }
  
  validates_presence_of :name, :phone
  validates_uniqueness_of :name
  
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  
  has_many :users
  default_scope where(published: true)
end