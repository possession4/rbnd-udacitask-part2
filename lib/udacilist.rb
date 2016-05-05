class UdaciList
  attr_reader :title, :items

  def initialize(options={})
    @title = options[:title]
    @items = []
  end
  def add(type, description, options={})
    type = type.downcase
    type_validate(type)

    @items.push TodoItem.new(description, options) if type == "todo"
    @items.push EventItem.new(description, options) if type == "event"
    @items.push LinkItem.new(description, options) if type == "link"

  end
  def delete(index)
    if (index-1 > @items.count)
      raise UdaciListErrors::IndexExceedsListSize, "Value #{index} is greater than the length of this list."
    else
      @items.delete_at(index - 1)
    end
  end
  def all
    puts "-" * @title.length
    puts @title
    puts "-" * @title.length
    @items.each_with_index do |item, position|
      puts "#{position + 1}) #{item.details}"
    end
  end

  def type_validate(type)
    unless (["todo","event","link"].include? type)
      raise UdaciListErrors::InvalidItemType, "Invalid Item Type: #{type}"
    end
  end
  
end
