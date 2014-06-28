class Article

  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :desc, type: String
  field :source_link, type: String
  field :publish_date, type: DateTime
  field :content, type: String

  belongs_to :user
end