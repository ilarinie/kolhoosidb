class TaskCompletion < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user ? controller.current_user : nil},
          recipient: Proc.new{ |controller, model| controller.find_commune_and_check_if_user },
          params: { "target_description" => proc { |controller, model| model.task.name },
                    "additional_information" => proc { |controller, model|  model.task.reward ? model.task.reward.to_s : '0' }}
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
