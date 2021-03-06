class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        #log in the user and redirect to the user's show page
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user )
        redirect_back_or user
      else
        # otherwise prompt to try again
        message = "Account not activate. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      #render error message and stay
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
