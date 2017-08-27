class Refund < ApplicationRecord
  belongs_to :sender, :class_name => 'User', :foreign_key => :to
  belongs_to :receiver, :class_name => 'User', :foreign_key => :from
end
