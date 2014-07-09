class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :name,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  validates :name, presence: true



  has_many :tweets, dependent: :destroy
  has_and_belongs_to_many :following, class_name: "User"
  has_and_belongs_to_many :followers, class_name: "User"

  def feed_key
    "#{self.id}_feed"
  end

  def remake_feed
    feed = []
    Tweet.in(user_id: self.following_ids).desc("created_at").limit(100).each do |tweet|
      feed << tweet.to_redis_json
    end
    $redis.set self.feed_key, feed
  end

  def update_tweet_hash(tweet)
    value = $redis.get(self.feed_key)
    if value
      new_value = JSON.parse(value)
    else
      new_value = []
    end
    new_value << tweet.to_redis_json
    $redis.set self.feed_key, new_value.to_json
  end


  class << self
    def serialize_from_session(key, salt)
      record = to_adapter.get(key[0]["$oid"])
      record if record && record.authenticatable_salt == salt
    end
end
end

