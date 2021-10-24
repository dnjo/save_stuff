class CreateRedditIntegrations < ActiveRecord::Migration[6.1]
  def change
    create_table :reddit_integrations do |t|
      t.string :access_token
      t.datetime :access_token_expires_at
      t.string :refresh_token
      t.string :scope
      t.string :username

      t.timestamps
    end
  end
end
