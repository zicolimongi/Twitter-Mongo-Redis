1000.times do |count|
  u = User.create(name: "Francisco Limongi #{count}", email: "zicolimongi#{count}@gmail.com",password: "minhasenha#{count}")
end

User.all.each do |user|
  100.times do |count|
    Tweet.create(user: user, description: "Meu tweet de número #{count}")
  end
end

User.all.each do |user|
  user.follower_ids = User.where(:id.ne => user.id).limit(10).map(&:id)
  user.following_ids = User.where(:id.ne => user.id).desc('id').limit(10).map(&:id)
  user.save
  p "remaking feed #{user.id}"
  user.remake_feed
end