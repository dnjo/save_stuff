class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, &:timestamps

    add_reference :integrations, :user, index: true, foreign_key: true
  end
end
