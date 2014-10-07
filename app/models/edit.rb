class Edit < ActiveRecord::Base
      belongs_to :response
      
      def edits_for_today(curdate)
        @edits = Edit.where("time = ?", curdate)
      end
end
