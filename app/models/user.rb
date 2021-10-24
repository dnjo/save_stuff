class User < ApplicationRecord
  has_many :integrations
  has_many :user_authentications

  def items
    integrations.flat_map(&:items)
  end

  def self.from_subject(subject)
    authentication = UserAuthentication.find_or_create_by(integration_identifier: subject)
    return authentication.user if authentication.user

    authentication.user = User.create
    authentication.save
    authentication.user
  end
end
