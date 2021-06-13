require 'date'

class BookingTour < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PHONE_REGEX = /\A(\d{3})-(\d{3})-(\d{4})\z/i
  VALID_DATE_REGEX =  /\A\d{2}\/\d{2}\/\d{4}\z/i

  belongs_to :user
  belongs_to :tour

  enum status: {waiting: 0, cancel: 1, approved: 2, rejected: 3, pending: 4}

  validates :start_date, presence: true
  validates :customer_name, presence: true
  validates :customer_email, presence: true, format: {with: VALID_EMAIL_REGEX}
  validates :customer_phone, presence: true, format: {with: VALID_PHONE_REGEX}
  validates :start_date, presence: true, format: {with: VALID_DATE_REGEX}
  validates :duaration, presence: true
  validates :quantity_person, presence: true, numericality: { only_integer: true }
  validates :price, presence: true
  validates :total_price, presence: true
  validate :valid_start_date, on: :create

  scope :sort_by_update_at, -> {order updated_at: :desc}
  scope :sort_by_start_date, -> {order start_date: :desc}
  scope :sort_by_created_at, -> {order created_at: :desc}
  private

  def valid_start_date
    return errors.add :start_date, "Ngày bắt đầu phải sau ngày hiện tại 5 ngày!" if start_date.present? && start_date.to_date < (Time.zone.today + 5.days)
  end
end
