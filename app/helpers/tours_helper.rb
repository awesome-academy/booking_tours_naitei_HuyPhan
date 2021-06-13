module ToursHelper
  def display_stars_layout tour
    points = tour.reviews.pluck :point
    if points.size != 0
    average_point = points.sum(0)/points.size 
    else
      average_point = 0
    end
    html_star_checked = ''

    (1..5).each do |index|
      checked = average_point >= index ? "fa-star checked" : "fa-star-o"
      html_star_checked << "<span class='fa #{checked}'></span>"
    end

    html_star_checked << "<span class='review-no ml-2'>(#{average_point} stars/ #{I18n.t "review", count: points.size})</span>"

    html_star_checked
  end

  def is_review? tour_id
    return if current_user.nil?
    has_tours_booking = current_user.booking_tours.approved.pluck :tour_id
    has_tours_booking.include? tour_id
  end

    def display_stars_review point
    html_star_checked = ''

    (1..5).each do |index|
      checked = point >= index ? "fa-star checked" : "fa-star-o"
      html_star_checked << "<span class='fa #{checked}'></span>"
    end

    html_star_checked
  end
end
