class Integration < ApplicationRecord
  belongs_to :listable, polymorphic: true
  belongs_to :user

  def items
    listable.items
  end
end
