class CreatePaypals < ActiveRecord::Migration
  def change
    create_table :paypals do |t|

      t.timestamps null: false
    end
  end
end
