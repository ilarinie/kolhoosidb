class Task < ApplicationRecord
belongs_to :commune
  has_many :task_completions
end
