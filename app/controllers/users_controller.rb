class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :followers, :followings]
  before_action :logged_in_user, only: [:show]
  before_action :correct_user, only: [:edit, :update]
  
  def new
      @user = User.new
  end
  
  def show
    @microposts = @user.microposts.order(created_at: :desc).page(params[:page])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      # 保存に成功した場合はトップページへリダイレクト
      redirect_to root_path , notice: 'Updated your profile'
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end
  
  def followings
    @title = 'followings'
    @users = @user.following_users.page(params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = 'followers'
    @users = @user.follower_users.page(params[:page])
    render 'show_follow'
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :region, :profile)
  end
  
  # beforeフィルター
  
  def correct_user
    redirect_to root_path if @user != current_user
  end
  
  def set_user
      @user = User.find(params[:id])
  end
  
end
