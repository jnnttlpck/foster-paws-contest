# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
20.times do
    submission = Submission.new(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        pet_name: Faker::Creature::Cat.name,
        location: Faker::Address.city,
        got_cat: Faker::Lorem.paragraph(sentence_count: 10),
        about: Faker::Lorem.paragraph(sentence_count: 20),
        status: :complete,
        year: 1.year.from_now.year,
        cat_age: "#{Faker::Number.number(digits: 2)} months"

    )
    url = Faker::LoremFlickr.image(search_terms: ['cat', 'kitten'])
    filename = 'cat.jpg'
    file = URI.open(url)
    submission.file.attach(io: file, filename: filename)
    submission.save

end

