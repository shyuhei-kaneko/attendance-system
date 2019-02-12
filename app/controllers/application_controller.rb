class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end

    # def arrival_h(temp_day)
    #   value = self.find_by(attendance_date: temp_day)
    #   # self.each do |atttendance|
    #     if value
    #       return value.arrival.strftime("%H")
    #     end
    #   # end
    # end
end
