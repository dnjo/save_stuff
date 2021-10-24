class CreateUserAuthentications < ActiveRecord::Migration[6.1]
  def change
    create_table :user_authentications do |t|
      t.string :integration_identifier
      t.belongs_to :user

      t.timestamps
    end
  end
end
