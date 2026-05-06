include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

inputs = {
  compartment_id    = include.root.locals.compartment_id
  region            = include.root.locals.region
}
