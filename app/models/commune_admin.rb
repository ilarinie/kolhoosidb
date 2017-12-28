class CommuneAdmin < ApplicationRecord
  belongs_to :commune
  belongs_to :user
  after_save :log_create

  def log_create
    message = "#{self.user.name} was promoted to admin by #{current_user.name}."
    CommuneLog.create(commune_id: self.commune_id, message: message, long_message: "")
  end
end
