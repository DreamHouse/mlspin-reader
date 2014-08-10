class Answer

  include Mongoid::Document
  include Mongoid::Timestamps
  
  # admin, agent, partner, standard
  field :content, type: String
    
  # public, public-hide-name, agent-only, default is public
  # This should be overriden by the question's answers_visibility
  field :visibility, type: String
  field :votes_up, type: Integer
  field :votes_down, type: Integer
  
  belongs_to :question
  belongs_to :user
  embeds_many :answerComments
end