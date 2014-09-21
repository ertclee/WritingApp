class PasswordsController < Devise::PasswordsController
	def after_sending_reset_password_instructions_path_for(resource_name)
      show_reset_password_path
    end
end
