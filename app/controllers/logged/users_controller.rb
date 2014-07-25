class Logged::UsersController < Logged::BaseController
  # GET /tweets
  # GET /tweets.json
  def index
    @users = User.where(:id.ne => current_user.id).paginate(:page => params[:page], :per_page => 30)
  end

  def followers
    @followers = current_user.followers.paginate(:page => params[:page], :per_page => 30)
  end

  def following
    @followings = current_user.following.paginate(:page => params[:page], :per_page => 30)
  end

  def show
    @user = User.find(params[:id])
    @tweets = @user.tweets.paginate(:page => params[:page], :per_page => 30)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to logged_tweets_path
    else
      render "edit"
    end
  end

  def destroy
    @user = current_user
    if @user.destroy
      redirect_to :home
    else
      render :edit
    end
  end

  def follow
    user = User.find(follow_params[:id])
    current_user.following_ids.push(user.id)
    user.follower_ids.push(current_user.id)
    respond_to do |format|
      if current_user.save && user.save
        current_user.remake_feed
        format.json { render json: user.to_json }
      else
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  def unfollow
    user = User.find(follow_params[:id])
    current_user.following_ids.delete(user.id)
    user.follower_ids.delete(current_user.id)
    respond_to do |format|
      if current_user.save && user.save
        current_user.remake_feed
        format.json { render json: user.to_json }
      else
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end

  end

  private
    def user_params
      params.require(:user).permit(:name,:email)
    end

    def follow_params
      params.require(:user).permit(:id)
    end
end
