class ApplicationController < ActionController::Base
   before_action :authorize

    protected
     def authorize
        if !User.find_by_id(session[:user_id])
                redirect_to login_url, notice: "Please log in"
        end
    end
end
