class Quiz < ApplicationRecord
  has_many :quiz_questions, dependent: :destroy

  DIFFICULTY = {
    "choking"    => { label: "Medium", bar: "bg-yellow-400", badge: "bg-yellow-100 text-yellow-700" },
    "bleeding"   => { label: "Easy",   bar: "bg-green-500",  badge: "bg-green-100 text-green-700"  },
    "poisoning"  => { label: "Hard",   bar: "bg-red-500",    badge: "bg-red-100 text-red-700"      },
    "heatstroke" => { label: "Easy",   bar: "bg-green-500",  badge: "bg-green-100 text-green-700"  }
  }.freeze

  def difficulty_label = DIFFICULTY.dig(topic_key, :label) || "Medium"
  def difficulty_bar   = DIFFICULTY.dig(topic_key, :bar)   || "bg-yellow-400"
  def difficulty_badge = DIFFICULTY.dig(topic_key, :badge) || "bg-yellow-100 text-yellow-700"

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