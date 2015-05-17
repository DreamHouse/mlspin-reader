class Article

  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :desc, type: String
  field :source_link, type: String
  field :publish_date, type: DateTime
  field :content, type: String
  field :author, type: String # original author
  field :published, type: Boolean
  
  has_and_belongs_to_many :tags
  
  belongs_to :user
  
  # default_scope where(published: true)
end