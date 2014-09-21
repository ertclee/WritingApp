class Profile < ActiveRecord::Base
	belongs_to :user
	has_attached_file :image, styles: { small: "64x64", med: "150x150", large: "200x200" }, :default_url => "missing.png"
	validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
