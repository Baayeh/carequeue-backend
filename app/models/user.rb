class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  attr_accessor :login

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self
  
  validates :name, :username, :email, :password, presence: true
  validates :username, uniqueness: { case_sensitive: false }

  def jwt_payload
    super
  end


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

end