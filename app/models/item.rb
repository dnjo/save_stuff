class Item
  attr_reader :id, :title, :url, :created

  def initialize(args)
    @id = args[:id]
    @title = args[:title]
    @url = args[:url]
    @created = args[:created]
  end
end
