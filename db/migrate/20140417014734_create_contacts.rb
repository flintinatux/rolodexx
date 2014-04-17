class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts, id: false do |t|
      t.string :id, limit: 36, primary: true, null: false
      t.string :name
      t.string :sex
      t.date   :birthday
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
