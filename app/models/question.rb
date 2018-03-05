class Question < ApplicationRecord
  has_many :answers
  
  validates_presence_of :title, :description
  validates :title, length: { minimum: 20 }
  validates :description, length: { minimum: 50 }
end
