class Tag

  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String
  field :value, type: String
  field :usage, type: String # merchant, article, question, etc
  
  validates_presence_of :name
  
  scope :merchant, where(usage: 'merchant')
  scope :question, where(usage: 'question')
end