class TodoItem
  include Listable
  attr_reader :description, :due, :priority

  def initialize(description, options={})
    @description = description
    @due = options[:due] ? Chronic.parse(options[:due]) : options[:due]
    priority = options[:priority]
    unless @priority.to_s.empty?
      priority_check(priority)
    end
    @priority = priority
  end

  def details
    format_description(@description) + "due: " +
    format_date(@due) +
    format_priority(@priority) 
  end

  def update_priority(new_priority)
    priority_check(new_priority)
    @priority = new_priority
  end

  def type
    "todo"
  end

  def priority_check(priority)
    unless (["high","medium","low"].include? priority)
      raise UdaciListErrors::InvalidPriorityValue, "Invalid Priority Value: #{priority}"
    end
  end
end
