module Listable
  extend ActiveSupport::Concern

  included do
    has_one :integration, as: :listable
  end
end
