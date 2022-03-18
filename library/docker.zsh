_woot_docker_has_image() {
  local image="$1"
  local image_id
  image_id="$(docker images "$image" --format '{{.ID}}')"
  if [ -n "$image_id" ]; then
    return 0
  else
    return 1
  fi
}

_woot_docker_image_age() {
  local image="$1"
  local image_id
  image_id="$(docker images "$image" --format '{{.ID}}')"
  if [ -n "$image_id" ]; then
    local image_age
    image_age="$(docker images "$image" --format '{{.CreatedSince}}')"
    echo "$image_age"
  fi
}
