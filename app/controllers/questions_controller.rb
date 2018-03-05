class QuestionsController < ApplicationController
  def index
    @questions = Question.order(updated_at: :desc)
  end

  def show
    @question = Question.find_by(id: params[:id])
    @errors = []
  end

  def new
    @question = Question.new
    @errors =[]
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

  private

  def question_params
    params.require(:question).permit(:title, :description)
  end


end
