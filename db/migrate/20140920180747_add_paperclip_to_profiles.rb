class AddPaperclipToProfiles < ActiveRecord::Migration
  def change
  	add_attachment :profiles, :image  
  end
end
