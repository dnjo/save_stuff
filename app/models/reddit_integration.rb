class RedditIntegration < ApplicationRecord
  include Listable

  def self.new_from_callback_code(code)
    request_params = {
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: 'http://localhost:3000/integration/callback/reddit'
    }
    connection = Faraday.new(url: 'https://www.reddit.com')
    connection.basic_auth(app_id, app_secret)
    response = JSON.parse(connection.post('/api/v1/access_token', request_params).body, symbolize_names: true)

    logger.debug { "Reddit response: #{response}" }

    integration = RedditIntegration.new
    integration.access_token = response[:access_token]
    integration.access_token_expires_at = DateTime.now + response[:expires_in].seconds
    integration.refresh_token = response[:refresh_token]
    integration.scope = response[:scope]
    integration.username = get_username(response[:access_token])
    integration.save
    integration
  end

  def self.get_username(access_token)
    url = 'https://oauth.reddit.com/api/v1/me'
    raw_response = Faraday.get(url) do |req|
      req.headers['Authorization'] = "Bearer #{access_token}"
    end
    response = JSON.parse(raw_response.body, symbolize_names: true)

    logger.debug { "Reddit response: #{response}" }

    response[:name]
  end
  private_class_method :get_username

  def items
    url = "https://oauth.reddit.com/user/#{username}/saved"
    raw_response = Faraday.get(url) do |req|
      req.headers['Authorization'] = "Bearer #{valid_access_token}"
    end
    response = JSON.parse(raw_response.body, symbolize_names: true)

    logger.debug { "Reddit response: #{response}" }

    response[:data][:children].map do |child|
      data = child[:data]
      item_data = {
        id: data[:id],
        title: data[:title],
        url: "https://www.reddit.com#{data[:permalink]}",
        created: Time.at(data[:created_utc]).to_datetime,
        thumbnail: filter_thumbnail(data[:thumbnail])
      }
      Item.new(item_data)
    end
  end

  private

  def filter_thumbnail(thumbnail)
    return nil if thumbnail.nil? || !thumbnail.start_with?('https://')

    thumbnail
  end

  def valid_access_token
    soon = DateTime.now + 1.minute
    return access_token if access_token_expires_at > soon

    logger.info 'Access token expires within 1 minute, refreshing'
    refresh_access_token
  end

  def refresh_access_token
    connection = Faraday.new(url: 'https://www.reddit.com')
    connection.basic_auth(app_id, app_secret)
    request_params = {
      grant_type: 'refresh_token',
      refresh_token: refresh_token
    }
    response = JSON.parse(connection.post('/api/v1/access_token', request_params).body, symbolize_names: true)

    logger.debug { "Reddit response: #{response}" }

    self.access_token = response[:access_token]
    self.access_token_expires_at = DateTime.now + response[:expires_in].seconds
    save

    access_token
  end

  def app_id
    Rails.application.credentials.reddit[:app_id]
  end

  def app_secret
    Rails.application.credentials.reddit[:app_secret]
  end

  def self.app_id
    Rails.application.credentials.reddit[:app_id]
  end
  private_class_method :app_id

  def self.app_secret
    Rails.application.credentials.reddit[:app_secret]
  end
  private_class_method :app_secret
end
