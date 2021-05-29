class Tour < ApplicationRecord
  belongs_to :category

  has_many :booking_tours, dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_one_attached :image

  scope :sort_by_name, -> {order name: :desc}
  scope :hot_tour, -> {join(:book_tours ).group(tour_id).last(6)}

  scope :search_by_duaration, ->duaration{where duaration: duaration if duaration.present?}

  scope :search_by_name, ->name{where("name like ?",  "%#{name}%") if name.present? }

  scope :sort_by_updated_at, -> {order updated_at: :desc}
end
