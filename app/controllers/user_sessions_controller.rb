class UserSessionsController < ApplicationController

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      flash[:success] = 'Successfully logged in'
      redirect_back_or_default(root_url)
    else
      render :action => "new"
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy if @user_session

    flash[:success] = 'Successfully logged out'
    redirect_back_or_default(root_url)
  end
end

