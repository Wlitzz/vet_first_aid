class QuizController < ApplicationController
  before_action :load_quiz, only: [ :show, :result ]

  def index
    @quizzes = Quiz.all
    @best_scores = session[:best_scores] || {}
  end

  def show
  end

  def result
    answers = params[:answers]&.permit!&.to_h || {}
    @score   = @quiz.score(answers)
    @total   = @quiz.quiz_questions.length
    @details = @quiz.result_details(answers)

    session[:best_scores] ||= {}
    prev_best = session[:best_scores][@quiz.topic_key].to_i
    @is_new_best = @score > prev_best
    session[:best_scores][@quiz.topic_key] = [ @score, prev_best ].max
  end

  private

  def load_quiz
    # Changed to find_by to search the string column instead of ID
    @quiz = Quiz.find_by(topic_key: params[:topic]) 
    redirect_to quiz_path unless @quiz
  end
end