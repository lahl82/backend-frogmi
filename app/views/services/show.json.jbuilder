# app/views/categories/show.json.jbuilder
json.id @service.id
json.title @service.title
json.description @service.description
json.price @service.price
json.service_type @service.service_type.name
json.service_type_id @service.service_type_id
json.user_id @service.user_id
json.url do
  json.array! @service.all_url_photos
end
