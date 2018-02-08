class RefundValidator < ActiveModel::Validator
  def validate(record)
    @commune = Commune.find(record.commune_id)
    @user1 = User.find(record.from)
    @user2 = User.find(record.to)
    user1_belongs_to_commune = (@commune.is_user(@user1) || @commune.is_admin(@user1))
    user2_belongs_to_commune = (@commune.is_user(@user2) || @commune.is_admin(@user2))
    unless user1_belongs_to_commune and user2_belongs_to_commune
      record.errors[:commune_violation] << 'Refunds are inter-commune only.'
    end
  end
end

class Refund < ApplicationRecord
  belongs_to :receiver, :class_name => 'User', :foreign_key => :to
  belongs_to :sender, :class_name => 'User', :foreign_key => :from
  validates_numericality_of :amount, less_than_or_equal_to: 100000000, greater_than: -100000000
  validates_with RefundValidator
end
