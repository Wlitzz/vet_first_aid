class QuizController < ApplicationController
  before_action :load_quiz, only: [ :show, :result ]

  def index
    @quizzes = Quiz.all # Changed from Quiz.topics to pull from the DB
  end

  def show
  end

  def result
    answers = params[:answers]&.permit!&.to_h || {}
    @score   = @quiz.score(answers)
    @total   = @quiz.quiz_questions.length # Updated relationship name
    @details = @quiz.result_details(answers)
  end

  private

  def load_quiz
    # Changed to find_by to search the string column instead of ID
    @quiz = Quiz.find_by(topic_key: params[:topic]) 
    redirect_to quiz_path unless @quiz
  end
end