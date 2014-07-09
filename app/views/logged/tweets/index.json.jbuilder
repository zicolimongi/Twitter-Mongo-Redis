json.array!(@tweets) do |tweet|
  json.extract! tweet, :id, :description
  json.url tweet_url(tweet, format: :json)
end
