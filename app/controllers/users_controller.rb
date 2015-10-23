class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
	before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    if !signed_in?
  	   @user = User.new
    else
      redirect_to root_path
    end
  end

  def destroy
    user = User.find(params[:id])
    if (user == current_user) && (current_user.admin?)
      flash[:error] = "You're admin. Can't destroy yourself."
    else
      user.destroy
      flash[:notice] = "User destroyed."
    end
    redirect_to users_path
  end

  def create
    if !signed_in?
  	   @user = User.new(params[:user])
  	   if @user.save
          sign_in @user
  		    flash[:success] = "Welcome to the Sample App!"
  		    redirect_to @user
  	   else
  		    render 'new'
  	   end
    else
        redirect_to root_path
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success]="Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
  	@users = User.paginate(page: params[:page])
  end

  private

  	def correct_user
  		@user = User.find(params[:id])
  		redirect_to(root_path) unless current_user?(@user)
  	end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
