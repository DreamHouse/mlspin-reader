class Propertyreview

  include Mongoid::Document
  include Mongoid::Timestamps
  
  # TODO: do we need tags for this too?
  field :tags, type: Array
  field :title, type: String
  field :content, type: String
  
  # Relations between propertyreviews
  has_many :replies, :class_name => 'Propertyreview'
  belongs_to :replied_to, :class_name => 'Propertyreview'
  
  belongs_to :home
  belongs_to :user
  
  
end