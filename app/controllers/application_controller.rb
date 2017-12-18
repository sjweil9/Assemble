class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    before_action :require_login

    def current_user
        if session[:user_id]
            columns = ['id', 'first', 'last', 'email', 'created_at', 'location', 'state']
            User.select(columns).find(session[:user_id])
        end
    end

    def get_states
        %w(AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY)
    end

    helper_method :current_user, :get_states

    private
        def require_login
            return redirect_to sign_in_path unless session.has_key?("user_id")
        end
end
