class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @user = User.find(current_user.id)
    end
  end

  def link
  end

  def about
  end

  def contact
  end
end