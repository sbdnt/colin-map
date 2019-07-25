class Claimed < ActiveRecord::Base
	belongs_to :user
	reverse_geocoded_by :latitude, :longitude
	after_validation :reverse_geocode  # auto-fetch address
end
