class Edit < ActiveRecord::Base
      belongs_to :response

      def create_new_edit_object(difference, response_id, time)
      	@edit = Edit.(:difference => difference, :response_id => response_id, :time => time)
      	@edit
      end
end
