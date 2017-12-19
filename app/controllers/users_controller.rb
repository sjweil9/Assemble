class UsersController < ApplicationController
    skip_before_action :require_login, except: [:edit, :update]

    def new
        return redirect_to events_path if session.has_key? "user_id"
        
        @states = get_states
    end

    def create
        user = User.new(user_params)
        unless user.save
            user.errors.each do |tag, error|
                flash[tag.to_sym] ||= []
                flash[tag.to_sym] << error unless error == "can't be blank"
            end
        else
            UserMailer.registration_confirmation(user).deliver
            flash[:success] = "Thanks for registering! Please check for a confirmation email sent to #{user.email} to verify account before signing in."
        end
        return redirect_to sign_in_path
    end

    def edit
        return redirect_to events_path unless session[:user_id].to_s == params[:id]
        @user = current_user
        @states = get_states
    end

    def update
        return redirect_to events_path unless params[:id] == session[:user_id].to_s
        
        user = User.find(session[:user_id])
        return redirect_to events_path unless user != nil
        
        user.update(update_params)
        if user.valid?
            flash[:success] = "Thanks! Your information was successfully updated."
        else
            user.errors.each do |tag, error|
                flash[tag.to_sym] ||= []
                flash[tag.to_sym] << error unless error == "can't be blank"
            end
        end
        return redirect_to edit_user_path(session[:user_id])
    end

    def confirm_email
        user = User.find_by(confirm_token: params[:token])
        if user
            user.activate_email
            flash[:success] = "Welcome to Assemble! Your email has been confirmed. Please sign in to continue."
            flash[:login] = true
        else
            flash[:not_found] = "Sorry, that user doesn't appear to exist."
        end
        return redirect_to sign_in_path
    end

    def unlock_account
        user = User.find_by(unlock_token: params[:token])
        if user
            user.unlock_account
            flash[:login] = true
            flash[:success] = "Your account has been successfully unlocked. Please sign in below."
        else
            flash[:not_found] = "Sorry, that user doesn't appear to exist."
        end
        return redirect_to sign_in_path
    end

    def forgot_pw
    end

    def send_reset
        user = User.find_by(email: params[:email])
        if user != nil
            user.update(reset_token: SecureRandom.urlsafe_base64.to_s, reset_token_time: DateTime.now)
            UserMailer.reset_password(user).deliver
            flash[:reset] = ["An email with instructions for resetting your password has been sent to #{user.email}."]
        else
            flash[:reset] = ["Could not find an account with that email address."]
        end
        return redirect_to forgot_password_path
    end

    def reset_pw_form
        @user_to_reset = User.find_by(reset_token: params[:token])
        if @user_to_reset == nil
            flash[:not_found] = "Sorry, that user doesn't appear to exist."
            return redirect_to sign_in_path
        end
        if @user_to_reset.reset_token_time + 2.hours < DateTime.now
            flash[:not_found] = "Sorry, that password reset token has expired. Please request a new one."
            return redirect_to sign_in_path
        end
    end

    def reset_pw
        user = User.find_by(email: params[:email])
        if user.reset_token != params[:token]
            flash[:not_found] = "Reset token invalid. Please try again."
            return redirect_to sign_in_path
        end
        if params[:password].empty?
            flash[:password] = ["Password may not be blank."]
            return redirect_to reset_password_form_path(user.reset_token)
        end
        user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        unless user.valid?
            user.errors.each do |tag, error|
                flash[tag.to_sym] ||= []
                flash[tag.to_sym] << error
            end
            return redirect_to reset_password_form_path(user.reset_token)
        end
        user.update(reset_token: nil, reset_token_time: nil)
        flash[:login] = true
        flash[:success] = "Password successfully reset. Please log in below."
        return redirect_to sign_in_path
    end

    private
        def user_params
            params.require(:user).permit(:first, :last, :email, :password, :password_confirmation, :location, :state)
        end

        def update_params
            params.require(:user).permit(:first, :last, :location, :state)
        end
end
