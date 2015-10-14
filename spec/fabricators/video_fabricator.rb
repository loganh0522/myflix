Fabricator(:video)
  title {Faker::Lorem.words(5)}
  description {Faker::Lorem.paragraph(2)}
end
