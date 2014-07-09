class Tweet
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description, type: String
  validates :description, presence: true
  validates :description, length: { maximum: 140 }

  belongs_to :user, validate: true

  after_create :update_hash

  def self.feed_of(user)
    value = $redis.get(user.feed_key)
    feed = []
    if value
      tweets_json = JSON.parse(value)
      tweets_json.each do |tweet|
        feed << JSON.parse(tweet)
      end
    end
    feed
  end

  def to_redis_json
    { description: self.description, user_name: self.user.name, created_at: self.created_at }.to_json
  end

  private
    def update_hash
      User.in(following_ids: [self.user_id]).each do |follower|
        follower.update_tweet_hash(self)
      end
    end
end
