class MembersController < ApplicationController
  before_action :logged_in_member, only: [ :index, :edit, :update, :destroy,
                                        :following, :followers ]
  before_action :correct_member,   only: [ :edit, :update ]
  before_action :admin_member,     only: :destroy

  def index
    @members = Member.where(activated: true).page(params[:page])
  end

  def show
    @member = Member.find(params[:id])
    redirect_to root_url and return unless @member.activated?
    @microposts = @member.microposts.page(params[:page])
  end
  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      @member.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "new", status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @member.update(member_params)
      flash[:success] = "Profile updated"
      redirect_to @member
    else
      render "edit", status: :unprocessable_content
    end
  end

  def destroy
    Member.find(params[:id]).destroy
    flash[:success] = "Member deleted"
    redirect_to members_url, status: :see_other
  end

  def following
    @title = "Following"
    @member = Member.find(params[:id])
    @members = @member.following.page(params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @member = Member.find(params[:id])
    @members = @member.followers.page(params[:page])
    render "show_follow"
  end

  private
    def member_params
      params.require(:member).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_member
      @member = Member.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_member?(@member)
    end

    def admin_member
      redirect_to(root_url, status: :see_other) unless current_member.admin?
    end
end
