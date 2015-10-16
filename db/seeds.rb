# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(title: "Futurama", description: "Awesome TV Show", small_cover_url: '/tmp/futurama.jpg', large_cover_url:'/tmp/futurama.jpg', category_id: '2')
monk = Video.create(title: "Monk", description: "Cool", small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: '1')
Video.create(title: "Futurama", description: "Awesome TV Show", small_cover_url: '/tmp/futurama.jpg', large_cover_url:'/tmp/futurama.jpg', category_id: '2')
Video.create(title: "Lord of the Rings", description: "Cool", small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: '1')
Video.create(title: "Futurama", description: "Awesome TV Show", small_cover_url: '/tmp/futurama.jpg', large_cover_url:'/tmp/futurama.jpg', category_id: '2')

Category.create(name: "Action")
Category.create(name: "Comedy")

logan = User.create(full_name: "Logan H", password: "password", email: "logan@example.com")
Review.create(user: logan, video: monk, rating: 5, content: "This is a really good video")
