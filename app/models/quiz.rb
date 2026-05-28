class Quiz < ApplicationRecord
  has_many :quiz_questions, dependent: :destroy

  def score(answers)
    quiz_questions.each_with_index.count do |q, i| 
      answers[i.to_s] == q.correct_answer 
    end
  end

  def result_details(answers)
    quiz_questions.each_with_index.map do |q, i|
      { 
        question: q, 
        user_answer: answers[i.to_s], 
        correct: answers[i.to_s] == q.correct_answer 
      }
    end
  end
end