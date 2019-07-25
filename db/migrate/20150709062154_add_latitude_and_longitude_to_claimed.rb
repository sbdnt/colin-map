class AddLatitudeAndLongitudeToClaimed < ActiveRecord::Migration
  def change
    add_column :claimeds, :latitude, :float
    add_column :claimeds, :longitude, :float
  end
end
