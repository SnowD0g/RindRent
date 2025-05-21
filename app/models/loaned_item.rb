class LoanedItem < ActiveRecord::Base
  validates :title, presence: true
  validates :friend_name, presence: true
  validates :loan_date, presence: true
end