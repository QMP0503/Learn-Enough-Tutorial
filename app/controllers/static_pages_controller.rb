class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @quote = current_member.quotes.build
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
