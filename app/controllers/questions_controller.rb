require 'pry'
class QuestionsController < ApplicationController
  def index
    @questions = Question.order(updated_at: :desc)
  end

  def show
    @question = Question.find_by(id: params[:id])
    @answers = @question.answers
    @answer = Answer.new
    @errors = []
  end

  def new
    @question = Question.new
    @errors =[]
  end

  def edit
    @question = Question.find(params[:id])
    @errors = []
  end

  def update
    # binding.pry
    @question = Question.find(params[:id])
    if @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated.'
    else
      @errors = @question.errors.full_messages
      render :edit
    end
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Question was successfully created.'
    else
      @errors = @question.errors.full_messages
      render :new
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @answers = @question.answers
    @question.destroy
    @answers.each do |answer|
      answer.destroy
    end

    redirect_to questions_path, notice: 'Article Deleted'
  end

  private

  def question_params
    params.require(:question).permit(:title, :description)
  end

end
