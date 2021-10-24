class CreateIntegrations < ActiveRecord::Migration[6.1]
  def change
    create_table :integrations, &:timestamps

    add_reference :integrations, :listable, polymorphic: true, index: true
  end
end
