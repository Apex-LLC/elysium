module ApplicationHelper

  def fading_flash_notice
    # note: you must have a div with id='notices' or rename the div appended to below with your element which
    # is the container for the flash messages       
    return '' if !flash[:notice]
    notice_id = rand.to_s.gsub(/\./, '')
    notice = <<-EOF
      $('#notices').append("<div id='#{notice_id}' class='flash_notice'>#{flash[:notice]}</div>");
      $("##{notice_id}").fadeOut(3500);
    EOF
    notice.html_safe
  end

  def current_account
    if (user_signed_in? && current_user.account != nil)      
      return current_user.account
    else
      redirect_to new_user_session_path
    end
  end

  def current_site
    if (user_signed_in?)
      if (current_account.site == nil)
        return Site.first
      else
        return current_account.site
      end
    else
      redirect_to new_user_session_path
    end
  end

  def get_tax_fee_rate
    return 0.10
  end

end
