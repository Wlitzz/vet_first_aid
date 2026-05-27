class QuizController < ApplicationController
  before_action :load_quiz, only: [ :show, :result ]

  def index
    @topics = Quiz.topics
  end

  def show
  end

  def result
    answers = params[:answers]&.permit!&.to_h || {}
    @score   = @quiz.score(answers)
    @total   = @quiz.questions.length
    @details = @quiz.result_details(answers)
  end

  private

  def load_quiz
    @quiz = Quiz.find(params[:topic])
    redirect_to quiz_path unless @quiz
  end
end
