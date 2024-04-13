# app/views/features/index.json.jbuilder
json.data do
  json.array! @features do |feature|
    json.id feature.id
    json.type 'Feature'

    json.attributes do
      json.external_id feature.external_id
      json.magnitude feature.magnitude
      json.place feature.place
      json.time feature.time
      json.tsunami feature.tsunami
      json.mag_type feature.mag_type
      json.title feature.title

      json.coordinates do
        json.longitude feature.longitude
        json.latitude feature.latitude
      end
    end

    json.links do
      json.external_url feature.external_url
    end
  end
end

json.pagination do
  json.current_page @current_page
  json.total @total
  json.per_page @per_page
end
