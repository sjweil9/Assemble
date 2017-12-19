class SessionsController < ApplicationController

    skip_before_action :require_login, except: [:destroy]

    def create
        user = User.find_by(email: params[:email])
        flash[:login] = true
        unless user
            flash[:email] = ["Email not found."]
            return redirect_to sign_in_path
        end
        unless user.email_confirmed
            flash[:success] = "Please activate your account by following the 
            instructions in the confirmation email sent to #{user.email}."
            return redirect_to sign_in_path
        end
        if user.account_locked
            flash[:password] = ["Your account has been locked after too many failed login attempts. An email with unlock instructions has been sent to #{user.email}."]
            return redirect_to sign_in_path
        end
        unless user.authenticate(params[:password])
            if (user.last_attempt + 1.hours).to_datetime > DateTime.now
                user.update(login_attempts: user.login_attempts + 1, last_attempt: DateTime.now)
            else
                user.update(login_attempts: 1, last_attempt: DateTime.now)
            end
            if user.login_attempts < 3
                flash[:password] = ["Password incorrect."] 
                flash[:password] << "You have now made #{user.login_attempts} failed attempts. You have #{3 - user.login_attempts} more attempts before being locked out."
            else
                user.update(account_locked: true, unlock_token: SecureRandom.urlsafe_base64.to_s)
                flash[:password] = ["You have now failed 3 login attempts within the last hour and your account has been locked. An email will be sent to #{user.email} with instructions to unlock your account."]
                UserMailer.unlock_account(user).deliver
            end
            return redirect_to sign_in_path
        end
        user.update(login_attempts: 0)
        session[:user_id] = user.id
        return redirect_to events_path
    end

    def destroy
        reset_session
        return redirect_to sign_in_path
    end
end
