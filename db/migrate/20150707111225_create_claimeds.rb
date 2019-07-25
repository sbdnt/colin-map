class CreateClaimeds < ActiveRecord::Migration
  def change
    create_table :claimeds do |t|
      t.integer :user_id
      t.string :address

      t.timestamps null: false
    end
  end
end
