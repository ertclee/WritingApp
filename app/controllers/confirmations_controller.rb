class ConfirmationsController < Devise::ConfirmationsController

  def show
    if params[:confirmation_token].present?
      @original_token = params[:confirmation_token]
    elsif params[resource_name].try(:[], :confirmation_token).present?
      @original_token = params[resource_name][:confirmation_token]
    end

    self.resource = resource_class.find_by_confirmation_token Devise.token_generator.
      digest(self, :confirmation_token, @original_token)

    super if resource.nil? or resource.confirmed?
  end

  def confirm
    @original_token = params[resource_name].try(:[], :confirmation_token)
    digested_token = Devise.token_generator.digest(self, :confirmation_token, @original_token)
    self.resource = resource_class.find_by_confirmation_token! digested_token
    resource.assign_attributes(permitted_params)
    @ip_address = local_ip
    @responses_with_no_writers = []
    @responses = Response.all
    @responses.each do |response|
      if response.writer.nil? 
        @responses_with_no_writers.push(response)
      end
    end 
    @response = find_response_with_matching_ip_address(@responses_with_no_writers, @ip_address)
    if @response.present? && @response.writer.nil?
      @response.update_attribute(:writer, params["user"]["name"])
    end
  
    if resource.valid? && resource.password_match?
      puts "about to confirm!!!!!!!!!"
      self.resource.confirm!
      set_flash_message :notice, :confirmed
      
      sign_in_and_redirect resource_name, resource
    else
      puts "about to confirm!!!!!!!!! else else"
      render :action => 'show'
    end
  end

 private
   def permitted_params
     params.require(resource_name).permit(:confirmation_token, :password, :password_confirmation, :name)
   end
 protected
   def after_resending_confirmation_instructions_path_for(resource_name)
      show_registration_path
   end
end