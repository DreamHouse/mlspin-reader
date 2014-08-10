class Question

  include Mongoid::Document
  include Mongoid::Timestamps
  
  # admin, agent, partner, standard
  field :tags, type: Array
  field :title, type: String
  field :content, type: String
  
  # House related questions
  field :house_link, type: String
  field :house_address, type: String
  
  # public, public-hide-name, agent-only, default is public
  field :visibility, type: String
  # public, asker-only, writer-only (include the users who answered), default is public
  field :answers_visibility, type: String
  
  has_many :answers
  belongs_to :user
end