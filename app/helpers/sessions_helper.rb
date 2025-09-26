module SessionsHelper
  def log_in(member)
    session[:member_id] = member.id
    session[:session_token] = member.session_token
  end

  def remember(member)
    member.remember
    cookies.permanent.encrypted[:member_id] = member.id
    cookies.permanent[:remember_token] = member.remember_token
  end

  def current_member
    if (member_id = session[:member_id])
      member = Member.find_by(id: member_id)
      if member && session[:session_token] == member.session_token
        @current_member = member
      end
    elsif (member_id = cookies.encrypted[:member_id])
      member = Member.find_by(id: member_id)
      if member && member.authenticated?(:remember, cookies[:remember_token])
        log_in member
        @current_member = member
      end
    end
  end

  def current_member?(member)
    member && member == current_member
  end

  def logged_in?
    !current_member.nil?
  end

  def forget(member)
    member.forget
    cookies.delete(:member_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_member)
    reset_session
    @current_member = nil
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
