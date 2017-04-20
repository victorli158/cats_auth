class User < ActiveRecord::Base
  validates :user_name, :session_token, :password_digest, presence: true
  validates :user_name, :session_token, uniqueness: true
  after_initialize :ensure_session_token

  attr_reader :password

  has_many :cats,
    foreign_key: :user_id,
    class_name: 'Cat'

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    pd = BCrypt::Password.create(password)
    pd == self.password_digest
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return user if user && BCrypt::Password.new(user.password_digest).is_password?(password)
    nil
  end
end
