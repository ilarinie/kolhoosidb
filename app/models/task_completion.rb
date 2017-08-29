class TaskCompletion < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user}, recipient: Proc.new{ |controller, model| controller.find_commune_and_check_if_user }
  belongs_to :task
  belongs_to :user

  def to_message
    if task.completion_text.nil?
      "#{self.user.name} just completed #{self.task.name}."
    else
      "#{self.user.name} #{self.task.completion_text}"
    end

  end
end
