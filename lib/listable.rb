module Listable
  def format_description(description)
    "#{description}".ljust(30)
  end
  def format_date(date1, date2 = "")
  	if(date2 == "")
    	date1 ? date1.strftime("%D") : "No due date"
	else
	    dates = @date1.strftime("%D") if @date1
	    dates << " -- " + @date2.strftime("%D") if @date2
	    dates = "N/A" if !dates
	    return dates
	end
  end
    def format_priority(priority)
    value = " ⇧".colorize(:red) if priority == "high"
    value = " ⇨".colorize(:yellow) if priority == "medium"
    value = " ⇩".colorize(:blue) if priority == "low"
    value = "" if !priority
    return value
  end
end
