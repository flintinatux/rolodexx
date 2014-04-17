class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses, id: false do |t|
      t.string :id, limit: 36, primary: true, null: false
      t.string :street
      t.string :city
      t.string :state, limit: 2
      t.string :postcode
      t.string :contact_id, limit: 36, primary: true, null: false

      t.timestamps
    end
  end
end
