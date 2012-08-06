class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy]
  before_filter :signed_user_no_need_for_signup, only: [:new, :create]

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    #@user = User.find(params[:id]) can be omitted cause private method correct_user
  end

  def update
    #@user = User.find(params[:id]) likewise ^
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy 
    temp = User.find(params[:id])
    if(!current_user?(temp))
      temp.destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    else
      flash[:error] = "Admins can't delete themselves."
      redirect_to users_path
    end
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def signed_user_no_need_for_signup
      redirect_to(root_path) unless !signed_in?
    end
end