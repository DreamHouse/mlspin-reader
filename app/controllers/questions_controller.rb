class QuestionsController < ApplicationController  
  before_filter :authenticate_user!, only: [:new, :create]
  
  layout "top_bar"
  
  def index
    @questions = Question.where(tags: params[:tag])
  end
  
  def new
  end
  
  def create
    unless user_signed_in?
      @error = :no_user
    else
      @question = Question.create!(params)
      @question.user = current_user
      @question.save!
    end
  end
  
  def show
    @question = Question.where(id: params[:id]).first
  end
end