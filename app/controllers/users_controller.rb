class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:notice] = 'Registration successful'
      redirect_back_or_default(root_url)
    else
      render :action => "new"
    end
  end

  def update
    @user = current_user

    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_back_or_default(root_url)
    else
      render :action => "edit"
    end
  end

  def destroy
    @user = current_user
    #@user.destroy #TODO something less destructive perhaps?

    redirect_to root_url
  end
end
