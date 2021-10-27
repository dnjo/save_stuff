class Item
  attr_reader :id, :title, :url, :created, :thumbnail

  def initialize(args)
    @id = args[:id]
    @title = args[:title]
    @url = args[:url]
    @created = args[:created]
    @thumbnail = args[:thumbnail]
  end
end
