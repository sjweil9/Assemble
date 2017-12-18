class UserMailer < ApplicationMailer
    def registration_confirmation(user)
        @user = user
        mail(:to => "#{user.first} #{user.last} <#{user.email}>", :subject => "Registration Confirmation for Assemble")
    end

    def unlock_account(user)
        @user = user
        mail(:to => "#{user.first} #{user.last} <#{user.email}>", :subject => "Unlock Your Assemble Account")
    end

    def reset_password(user)
        @user = user
        mail(:to => "#{user.first} #{user.last} <#{user.email}>", :subject => "Reset Your Assemble Password")
    end
end
