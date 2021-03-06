class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update, :destroy]

  def index
    @user_count = User.count
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(params[:user])

    if verify_recaptcha(:model => @user) && @user.save
      flash[:success] = 'Registration successful'
      redirect_to welcome_path
    else
      render :action => "new"
    end
  end

  def update
    @user = current_user

    if @user.update_attributes(params[:user])
      flash[:success] = 'User information successfully updated'
      redirect_back_or_default(guidelines_url)
    else
      render :action => "edit"
    end
  end

#TODO something less destructive perhaps?
#  def destroy
#    @user = current_user
#    #@user.destroy

#    redirect_to root_url
#  end

end

