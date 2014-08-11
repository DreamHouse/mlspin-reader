class AnswersController < ApplicationController  
  before_filter :authenticate_user!, only: [:create]
  
  layout "top_bar"
  
  def create
    unless user_signed_in?
      @error = :no_user
    else
      @question = Question.find(params[:question_id])
      if @question
        @answer = Answer.create!(content: params[:content][0])
        @answer.user = current_user
        @answer.question = @question
        @answer.save!
        redirect_to question_path(@question)
      else
        @error = :no_question
      end
    end
  end
end