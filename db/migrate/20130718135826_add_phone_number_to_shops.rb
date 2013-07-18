class AddPhoneNumberToShops < ActiveRecord::Migration
  def change
    add_column :shops, :phone_number, :string
  end
end
