json.array!(@claimeds) do |claimed|
  json.extract! claimed, :id, :user_id, :longitude, :latitude, :address
  json.url claimed_url(claimed, format: :json)
end
