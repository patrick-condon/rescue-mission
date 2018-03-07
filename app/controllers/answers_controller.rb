require 'pry'
class AnswersController < ApplicationController
  def index
    @question = Question.find(params[:question_id])
    @answers = Answer.order(updated_at: :desc)
  end

  def update
    @question = Question.find(params[:question_id])
    @current_best = nil
    @question.answers.each do |answer|
      if answer.best == true
        @current_best = answer
      end
    end
    @new_best = Answer.find(params[:id])
    if @current_best != nil
      @current_best.update(best: false)
    end
    @new_best.update(best: true)
    redirect_to @question
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
    params.require(:answer).permit(:description, :best)
  end


end
