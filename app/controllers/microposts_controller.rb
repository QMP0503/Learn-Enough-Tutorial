class MicropostsController < ApplicationController
  before_action :logged_in_member, only: [ :create, :destroy ]
  before_action :correct_member,   only: :destroy

  def create
    @micropost = current_member.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_member.feed.page(params[:page])
      render "static_pages/home", status: :unprocessable_content
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    if request.referrer.nil? || request.referrer == microposts_url
      redirect_to root_url
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end

    def correct_member
      @micropost = current_member.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
