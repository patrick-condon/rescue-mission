require 'pry'
class AnswersController < ApplicationController
  def index
    @question = Question.find(params[:question_id])
    @answers = Answer.order(updated_at: :desc)
  end

  def update
    @question = Question.find(params[:question_id])
    @current_bests = @question.answers.where(best: true)
    @new_best = Answer.find(params[:id])
    if @current_bests != nil
      @current_bests.each do |answer|
        answer.update(best: false)
      end
    end
    @new_best.update(best: true)
    redirect_to @question, notice: 'Best Answer Selected'
  end

  def create
    @question = Question.find_by(id: params[:question_id])
    @answer = Answer.new(answer_params)
    @answer.question = @question

    if @answer.save
      redirect_to @question, notice: 'Answer was successfully created.'
    else
      @answers = []
      @best_answer = nil
      @question.answers.order(:created_at).each do |a|
        if a.best == true
          @best_answer = markdown.render(a.description).html_safe
        else
         @answers << {description: markdown.render(a.description).html_safe, id: a.id}
        end
      end
      @errors = @answer.errors.full_messages
      render '/questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:description, :best)
  end

  def markdown
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true,
      lax_spacing: true, quote: true, fenced_code_blocks: true, strikethrough: true,
      underline: true)
  end

end
