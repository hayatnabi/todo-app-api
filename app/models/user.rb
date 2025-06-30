class User < ApplicationRecord
  has_secure_password
  has_many :todos
  validates :email, presence: true, uniqueness: true

  def generate_password_token!
    self.reset_password_token = SecureRandom.hex(10)
    self.reset_password_sent_at = Time.current
    save!
  end
  
  def password_token_valid?
    (self.reset_password_sent_at + 2.hours) > Time.current
  end
  
  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end
end
