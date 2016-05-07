class UdaciList
  attr_reader :title, :items

  def initialize(options={})
    @title = options[:title] || ""
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
  def all (options={})
    # puts "-" * @title.length
    # puts @title
    # puts "-" * @title.length
    # @items.each_with_index do |item, position|
    #   puts "#{position + 1}) #{item.details}"
    # end

    if (@title.length > 0)
      puts "-" * @title.length
      puts @title
      puts "-" * @title.length
    end
    table_data = []
    item_type = options[:item_filter] || ""
    if (item_type.empty?)
      @items.each_with_index do |item, position|
        table_data  << {"ListNumber".colorize(:white) => position + 1, "Details".colorize(:white)  => item.details, "Type".colorize(:white)  => item.type}
      end
    else
      @items.select{|item| item.type==item_type }.each_with_index do |item, position|
        table_data  << {"ListNumber".colorize(:white) => position + 1, "Details".colorize(:white)  => item.details, "Type".colorize(:white)  => item.type}
      end
      item_length_check(table_data, item_type)
    end
    puts Formatador.display_table(table_data)
  end

  def filter(item_type)
    type_validate(item_type)
    all(item_filter:item_type)
  end

  def type_validate(type)
    unless (["todo","event","link"].include? type)
      raise UdaciListErrors::InvalidItemType, "Invalid Item Type: #{type}"
    end
  end

  def item_length_check(table_data, item_type)
    unless (table_data.length > 0)
      raise UdaciListErrors::NoItemTypeFound, "No Items Found With Item Type: #{item_type}"
    end
  end
end
