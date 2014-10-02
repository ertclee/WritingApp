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

  def after_confirmation
    @user = self
    @ip_address = local_ip
    @responses_with_matching_writers = []
    @responses = Response.all
    @responses.each do |response|
      if response.writer == @user.name
        @responses_with_matching_writers.push(response)
      end
    end
    @response = find_response_with_matching_ip_address(@responses_with_matching_writers, @ip_address)
    if @response.present?
      @user.responses << @response
    end
  end

  private
    def add_profile
      self.build_profile(:daily_email_reminder => true, :daily_goal => 100)
    end

    require 'socket'
    def local_ip
      orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

      UDPSocket.open do |s|
        s.connect '64.233.187.99', 1
        s.addr.last
      end
    ensure
      Socket.do_not_reverse_lookup = orig
    end

    def find_response_with_matching_ip_address(responses, local_ip)
      puts "enters here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      responses.each do |response|
        puts "response ip adress is ", response.ip_address
        puts "local_ip is ", local_ip
        if response.ip_address == local_ip
          puts "enters the equality of ip address!!!!!!!"
          puts "response is ", response
          return response
        end
      end
      puts "end of the loop"
    end
end
