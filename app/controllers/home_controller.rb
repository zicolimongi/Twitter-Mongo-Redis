class HomeController < ApplicationController
  def index
    if current_user
      redirect_to logged_tweets_path
    end
  end

  def about
  end
end
