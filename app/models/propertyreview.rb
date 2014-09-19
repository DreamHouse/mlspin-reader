class Propertyreview

  include Mongoid::Document
  include Mongoid::Timestamps
  
  # TODO: do we need tags for this too?
  field :tags, type: Array
  field :title, type: String
  field :content, type: String
  
  has_many :answers
  belongs_to :home
  belongs_to :user
end