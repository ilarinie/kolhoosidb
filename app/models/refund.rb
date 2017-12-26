class Refund < ApplicationRecord
  belongs_to :sender, :class_name => 'User', :foreign_key => :to
  belongs_to :receiver, :class_name => 'User', :foreign_key => :from
  validates_numericality_of :amount, less_than_or_equal_to: 100000000, greater_than: -100000000
end
