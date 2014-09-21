class AddColumnStringDeliveryAt < ActiveRecord::Migration
  def change
    add_column :email_messages, :string_delivery_at, :string
  end
end
