ActiveAdmin.register EmailMessage do

  form :partial => "form"
  
  index do
    selectable_column
    column :id
    column :subject
    column :deliver_at do |em|
      em.deliver_at.strftime("%H:%M")
    end
    actions :defaults => true
  end

  show do
    panel 'Email Message Details' do
      attributes_table_for email_message do
        row :subject
        row :message
        row('deliver at') { |em|
          "#{em.deliver_at.strftime("%H:%M")}"
        }
        row :updated_at
      end
    end
  end
  #form :partial => "form"
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :subject, :message, :deliver_at, :string_delivery_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end


end
