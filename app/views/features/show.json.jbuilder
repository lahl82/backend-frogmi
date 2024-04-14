# app/views/features/show.json.jbuilder
json.id @feature.id
json.type 'Feature'

json.attributes do
  json.external_id @feature.external_id
  json.magnitude @feature.magnitude
  json.place @feature.place
  json.time @feature.time
  json.tsunami @feature.tsunami
  json.mag_type @feature.mag_type
  json.title @feature.title

  json.coordinates do
    json.longitude @feature.longitude
    json.latitude @feature.latitude
  end
end

json.links do
  json.external_url @feature.external_url
end
