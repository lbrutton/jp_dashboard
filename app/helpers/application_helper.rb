module ApplicationHelper
  
  def cvr(installs,clicks)
      if clicks == 0
        @cvr = 0
      else
        @cvr = installs/clicks
      end
      return @cvr.round(2)
  end
  
  def ecpi(installs,spend)
    if installs == 0
      ecpi = "N/A"
    else
      ecpi = (spend/installs).round(2)
    end
    return ecpi
  end
  
end
