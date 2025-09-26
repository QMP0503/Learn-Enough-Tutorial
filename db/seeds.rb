# Create a main sample member.
Member.create!(name:  "Example Member",
              email: "example@railstutorial.org",
              password:              "foobar",
              password_confirmation: "foobar",
              admin: true,
              activated: true,
              activated_at: Time.zone.now)

# Generate a bunch of additional members.
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  Member.create!(name:  name,
                email: email,
                password:              password,
                password_confirmation: password,
                activated: true,
                activated_at: Time.zone.now)
end

# Generate microposts for a subset of members.
members = Member.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  members.each { |member| member.microposts.create!(content: content) }
end

# Create following relationships.
members = Member.all
member  = members.first
following = members[2..50]
followers = members[3..40]
following.each { |followed| member.follow(followed) }
followers.each { |follower| follower.follow(member) }
