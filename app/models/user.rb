class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable
  has_many :responses
  has_many :writing_challenges
  has_one :profile
  scope :confirmed, -> { where("confirmed_at is NOT NULL") }  
  before_create :add_profile
  

  def password_required?
    super if confirmed?
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  def email_uniqueness
    self.errors.add(:base, 'User with that email already exists. Please try another email address.') if User.where(:email => self.email).exists?
  end

  private
    def add_profile
      self.build_profile(:daily_email_reminder => true, :daily_goal => 100)
    end
end
