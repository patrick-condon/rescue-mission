require 'pry'
require 'redcarpet'

class QuestionsController < ApplicationController
  def index
    @questions = Question.order(updated_at: :desc)
  end

  def show
    @question = Question.find_by(id: params[:id])
    @question_description = markdown.render(@question.description).html_safe
    @answers = []
    @best_answer = nil
    @question.answers.order(:created_at).each do |a|
      if a.best == true
        @best_answer = markdown.render(a.description).html_safe
      else
       @answers << {description: markdown.render(a.description).html_safe, id: a.id}
      end
    end
    @answer = Answer.new
    @errors = []
  end

  def new
    @title = "New Question"
    @question = Question.new
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  def create
    @question = Question.new(question_params)    

    if @question.save
      redirect_to @question, notice: 'Question was successfully created.'
    else
      @title = 'New Question'
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

  def markdown
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true,
      lax_spacing: true, quote: true, fenced_code_blocks: true, strikethrough: true,
      underline: true)
  end

end
