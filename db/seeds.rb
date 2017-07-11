Answer.destroy_all
Question.destroy_all

100.times do
  Question.create title: Faker::ChuckNorris.fact,
                  body: Faker::Hacker.say_something_smart,
                  view_count: rand(1000)

end

questions = Question.all

questions.each do |q|
  rand(1..5).times do
    Answer.create(body: Faker::RickAndMorty.quote, question: q)
  end
end

answers = Answer.all

puts Cowsay.say('Created 100 questions', :cow)
puts Cowsay.say("Created #{answers.count} answers", :ghostbusters)
