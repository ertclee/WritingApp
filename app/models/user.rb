class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable
  has_many :responses
  has_one :profile
  scope :confirmed, -> { where("confirmed_at is NOT NULL") }  
  before_create :add_profile

  def words_since_signup
    count = 0
    self.responses.each { |response| count += response.wordcount.to_i }
    count
  end

  def writing_challenges
    challenges = []
    self.responses.each {|response| challenges.push response.writing_challenge}
    challenges
  end

  def words_this_month
    count = 0
    self.responses.where('extract(month from updated_at) = ?', Time.now.month).each { |response| count += response.wordcount.to_i }
    count
  end
  
   def words_for_day date
    @wordcount = 0
    @edits = edits_on_same_date date
    @responses = responses_on_same_date date
    @editcount = 0
    @responsecount = 0
    @edits.each do |edit|
      @editcount += edit.difference
    end
    @responses.each do |response|
      @responsecount += response.wordcount.to_i
    end
    @wordcount = @editcount + @responsecount
    return @wordcount
  end

#REFACTOR
  def words_by_day(start_date)
    number_of_words = Hash.new
    already_calculated_edits = Hash.new
    (start_date..start_date + 1.month).each { |d| number_of_words["#{d.strftime('%d-%m-%Y')}"] = words_for_day(d) }
#    self.responses.each { |response|
#      numedits = 0
#      @edits = self.edits_on_same_date response.time
#      @edits.each do |edit|
#        print "STARTING EDIT SEARCH"
#        if !already_calculated_edits.has_key?(edit.id)
#          numedits += edit.difference
#          already_calculated_edits[edit.id] = 1
#        end
#      end
#      number_of_words["#{response.time.to_date.strftime('%d-%m-%Y')}"] += (response.wordcount.to_i + numedits)
#    }
    number_of_words
  end
  
   def responses_on_same_date date
    print "STARTIN SEARCH RESPONSES\n"
    @responses = []
    @allresponses = Response.all
    if @allresponses == nil
      return @responses
    end
    @allresponses.each do |response|
      print "RESULT: " + response.inspect
      if response.time != nil
        if response.time.strftime('%d-%m-%Y') == date.strftime('%d-%m-%Y')
          @responses.push(response)
        end
      end
    end
    print @responses.inspect
    print "END FOUND ALL RESPONSES\n"
    @responses
  end
  
  
  def edits_on_same_date date
    print "STARTIN SEARCH\n"
    @edits = []
    @alledits = Edit.all
    if @alledits == nil
      return @edits
    end
    @alledits.each do |edit|
      print "RESULT: " + edit.inspect
      if edit.time != nil
        if edit.time.strftime('%d-%m-%Y') == date.strftime('%d-%m-%Y')
          @edits.push(edit)
        end
      end
    end
    print @edits.inspect
    print "END FOUND ALL EDITS\n"
    @edits
  end

  
 #def words_for_day(date, responses)
 #   @wordcount = 0
 #   responses.each do |response| 
 #     if response.created_at.strftime('%d-%m-%Y') == date.strftime('%d-%m-%Y')
 #       @wordcount += response.wordcount.to_i
 #       @edit_for_response = Edit.where("response_id = ? AND user_id = ? ", response.id, 1)
 #        if @edit_for_response.present? 
 #          @wordcount -= @edit_for_response[0].difference
 #        end
 #     else
 #        @current_user_id = 1 #replace this with current_user id
  #       @edit_for_response = Edit.where("response_id = ? AND user_id = ? AND time = ?", response.id, 1, date.strftime("%Y-%m-%d"))
  #       puts @edit_for_response 
  #       if @edit_for_response
  #         @wordcount += @edit_for_response[0].difference
  #       end
  #    end
  #  end
  #  @wordcount
  #end

  # REFACTOR
  def words_by_day(start_date)
    number_of_words = Hash.new
    @responses = Response.all
    (start_date..(start_date + 1.month - 1.day)).each { |d| number_of_words["#{d.strftime('%m-%d-%Y')}"] = words_for_day(d) }
    number_of_words
  end

  def signup_date
    self.created_at.localtime.strftime('%Y-%m-%d')
  end

  def max_value_for_yaxis
    longest_response_count_so_far = 0
    longest_response_count_so_far = self.responses.max_by { |response| response.wordcount.to_i }
    unless longest_response_count_so_far.nil?
      longest_response_count_so_far.wordcount
    end
  end

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
    responses.each do |response|
      if response.ip_address == local_ip
        return response
      end
    end
  end
end
