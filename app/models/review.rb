class Review < ApplicationRecord
  belongs_to :user
  belongs_to :tour
  has_many :comments

  enum status: {waiting: 0, rejected: 1, view: 2}

  scope :sort_by_created_at, -> {order created_at: :desc}
  scope :sort_by_status, -> {order :status}
end
