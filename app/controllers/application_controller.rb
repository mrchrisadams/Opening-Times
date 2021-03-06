# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user, :lockdown?
  filter_parameter_logging :password, :password_confirmation

#  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  private

    # Stop all editing
    def lockdown?
      return false
    end

    def check_lockdown
      render 'partials/_lockdown' if lockdown?
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def require_user
      unless current_user
        store_location
        flash[:info] = "You must be logged in to access this page"
        redirect_to login_path
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:info] = "You must be logged out to access this page"
        redirect_to root_path
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def check_user
      require_user
      unless current_user.within_action_limit?
        render 'users/_reached_limit'
        return
      end
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

end

