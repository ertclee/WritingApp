class AddIpAddressToResponses < ActiveRecord::Migration
  def change
  	add_column :responses, :ip_address, :string
  end
end
