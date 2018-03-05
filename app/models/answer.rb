class Answer < ApplicationRecord
  belongs_to :question
  
  validates_presence_of :question_id, :description
  validates :description, length: { minimum: 50 }
end
