class QuizQuestion < ApplicationRecord
  belongs_to :quiz
  belongs_to :first_aid_procedure
end
