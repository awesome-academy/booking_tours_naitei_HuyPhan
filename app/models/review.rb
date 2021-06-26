class Review < ApplicationRecord

  
  belongs_to :user
  belongs_to :tour
  has_many :comments

  enum status: {waiting: 0, rejected: 1, view: 2}
  enum feel_status: {not_analyzed: 2, positive: 0, negative: 1}
  scope :sort_by_created_at, -> {order created_at: :desc}
  scope :sort_by_status, -> {order :status}

  scope :search_by_key, ->key{where("content like ? or title like ?",  "%#{key}%", "%#{key}%") if key.present? }
  scope :search_by_tour_id, ->tour_id{joins(:tour).where("tours.id = ?",  "#{tour_id}") if tour_id.present? }
  scope :search_by_created_at, ->time{where(:created_at => time.beginning_of_day..time.end_of_day) if time.present? }
  scope :search_by_feel_status, ->feel_status{where("feel_status = ? ",  "#{feel_status.to_i}") unless feel_status.blank? }
end
