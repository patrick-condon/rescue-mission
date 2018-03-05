require 'pry'
class AnswersController < ApplicationController
  def index
    @question = Question.find(params[:question_id])
    @answers = Answer.order(updated_at: :desc)
  end

  def show
    @answer = Answer.find_by(id: params[:id])
    @question = @answer.question
    if @question.answers
      @answers = @question.answers
    else
      @answers = []
    end
    @errors = []
  end

  def new
    @question = Question.find(params[:question_id])
    @answer = Answer.new
    @errors =[]
  end

  def create
    @question = Question.find_by(id: params[:question_id])
    @answer = Answer.new(answer_params)
    @answer.question = @question

    if @answer.save
      redirect_to @question, notice: 'Answer was successfully created.'
    else
      @answers = @question.answers
      @errors = @answer.errors.full_messages
      render '/questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:description)
  end


end
