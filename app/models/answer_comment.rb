class AnswerComment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :content, type: String
  
  belongs_to :user
  embedded_in :answer
end