class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_member.microposts.build
      @feed_items = current_member.feed.page(params[:page])
    end
  end

  def about
  end

  def contact
  end

  def help
  end
end
