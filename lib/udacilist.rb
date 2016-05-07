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

  def delete(*list_values)
    list_values.each do |list_value| 
      unless (list_value-1 < @items.count)
        raise UdaciListErrors::IndexExceedsListSize, "Value #{list_values} is greater than the length of this list."
      end
    end
    list_values = list_values.map { |list_number| list_number - 1 }
    @items.delete_if.with_index { |item, index| list_values.include? index }
  end

  def update_priority(list_item_number, new_priority)
    @items.each_with_index  do |item,index|
      if (index == list_item_number - 1)
          item.update_priority(new_priority)
      end
    end
  end

  def all (options={})
    if (@title.length > 0)
      puts "-" * @title.length
      puts @title
      puts "-" * @title.length
    end
    rows = []
    item_type = options[:item_filter] || ""
    if (item_type.empty?)
      @items.each_with_index do |item, position|
        rows  << [position + 1, item.details, item.type]
      end
    else
      @items.select{|item| item.type==item_type }.each_with_index do |item, position|
        rows  << [position + 1, item.details, item.type]
      end
      list_length_check(rows, item_type)
    end

    table = Terminal::Table.new :headings => ['List Number', 'Details', 'Type'], :rows => rows
    puts table
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

  def list_length_check(list, item_type)
    unless (list.length > 0)
      raise UdaciListErrors::NoItemTypeFound, "No Items Found With Item Type: #{item_type}"
    end
  end
end
