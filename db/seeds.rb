admin = User.new(
  name: "Admin",
  email: "admin@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  role: User.roles[:admin],
  address: Faker::Address.full_address,
  phone: Faker::PhoneNumber.cell_phone
)
admin.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'home', 'admin.jpg')),
      filename: 'admin.jpg',
      content_type: 'image/jpg')
admin.save

# Create list customer
4.times do |n|
  name = Faker::Name.name
  email = "user-#{n}@gmail.com"
  u = User.new(
    name: name,
    email: email,
    password: "123456",
    password_confirmation: "123456",
    role: User.roles[:customer],
    address: Faker::Address.full_address,
    phone: Faker::Base.numerify('###-###-####')
  )
  u.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'home', 'user.jpeg')),
      filename: 'user.jpeg',
      content_type: 'image/jpeg')
  u.save
end

3.times do |n|
  Category.create(
    name: Faker::Ancient.primordial,
    description: Faker::TvShows::Community.quotes
  )
end

Category.all.each do |category|
  10.times do |n|
    place = Faker::Address.city
    t = Tour.new(
      name: "Travel to " + place,
      description: Faker::Lorem.paragraph(sentence_count: 30, supplemental: false, random_sentences_to_add: 10),
      duaration: rand(2..5),
      category_id: category.id,
      price: Faker::Number.decimal(l_digits: 3, r_digits: 2)
    )

    t.image.attach(
      io: File.open(Rails.root.join('app', 'assets', 'images', 'tour.jpg')),
      filename: 'tour.jpg',
      content_type: 'image/jpg'
    )
    t.save
  end
end

# # reviews
Tour.all.each do |tour|
  (0..5).each do
    tour.reviews.create  title: Faker::Lorem.sentence(word_count: 20),content: Faker::Lorem.paragraph(sentence_count: 50, supplemental: false, random_sentences_to_add: 10), user_id: User.all.pluck(:id).sample, point: rand(2..5), status: Review.statuses.keys.sample
  end
end

# comments
Review.all.each do |review|
  (0..5).each do
    review.comments.create content: Faker::Lorem.sentence(word_count: 50), user_id: User.all.pluck(:id).sample
  end
end


## Booking tour
(1..50).each do |i|
  BookingTour.create(
    start_date: '26/05/2021',
    customer_name: "Customer #{i}",
    customer_email: "Customer#{i}@gmail.com",
    customer_phone: '208-070-3179',
    tour_id:Tour.all.pluck(:id).sample,
    user_id: User.all.pluck(:id).sample,
    created_at: (1..12).to_a.sample.months.ago,
    duaration: rand(1..10),
    quantity_person: rand(1..10),
    note: "note #{i}",
    price: rand(100..300),
    total_price: rand(100..1200)
    )
end