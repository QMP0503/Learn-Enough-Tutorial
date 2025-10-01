class QuotesController < ApplicationController
  before_action :logged_in_member, only: [ :create, :destroy ]
  before_action :correct_member,   only: :destroy

  def create
    @quote = current_member.quotes.build(quote_params)
    @quote.image.attach(params[:quote][:image])
    if @quote.save
      flash[:success] = "Quote created!"
      redirect_to root_url
    else
      @feed_items = current_member.feed.page(params[:page])
      render "static_pages/home", status: :unprocessable_content
    end
  end

  def destroy
    @quote.destroy
    flash[:success] = "Quote deleted"
    if request.referrer.nil? || request.referrer == quotes_url
      redirect_to root_url
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def quote_params
      params.require(:quote).permit(:content, :image)
    end

    def correct_member
      @quote = current_member.quotes.find_by(id: params[:id])
      redirect_to root_url if @quote.nil?
    end
end
