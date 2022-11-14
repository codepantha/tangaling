# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

user1 = User.create!(
  first_name: 'Joan',
  last_name: 'Exra',
  email: 'joan@example.com',
  username: 'jojo'
)

user2 = User.create!(
  first_name: 'Adnan',
  last_name: 'Becker',
  email: 'adnan@example.com',
  username: 'becks'
)

Bond.create(user: user1, friend: user2, state: Bond::FOLLOWING)
Bond.create(user: user2, friend: user1, state: Bond::FOLLOWING)

place = Place.create!(
  locale: "en",
  name: "Hotel Majapahit",
  place_type: "hotel",
  coordinate: "POINT (112.739898 -7.259836 0)"
)

post = Post.create!(user: user1, postable: Status.new(text: 'Whoohooo! I am the MAN!!'))

Post.create!(user: user2, postable: Status.new(
  text: 'Wow! Looks great! Haave fun , Joan!'
), thread: post)

Post.create!(user: user1, postable: Status.new(
  text: 'Ya! Ya! Ya! Are you in town?'
), thread: post)

Post.create!(user: user2, postable: Status.new(
  text: "Yups! Let's explore the city!"
), thread: post)

Post.create!(user: user1, postable: Sight.new(
  place: place, activity_type: Sight::CHECKIN
))
