locals {
  custom_role_profiles = {
    for profile, actions in local.cfg_role_profile_actions : profile => actions
    if profile != "space-admin"
  }
}

resource "spacelift_role" "profile" {
  for_each = local.cfg_enable_custom_role_profiles ? local.custom_role_profiles : {}

  name    = "${local.cfg_naming_org}-${local.cfg_naming_domain}-${local.cfg_naming_function_role_prefix}-${each.key}"
  actions = each.value
}

locals {
  created_role_profile_slugs = {
    for profile, role in spacelift_role.profile : profile => role.name
  }

  role_profile_slugs = merge(local.cfg_role_profile_role_slugs, local.created_role_profile_slugs)
  created_role_slugs = toset(values(local.created_role_profile_slugs))
  external_role_slugs = toset([
    for slug in values(local.role_profile_slugs) : slug if !contains(local.created_role_slugs, slug)
  ])
}

# Resolve only externally managed role slugs.
# Custom roles created in this run are resolved directly from resources.
data "spacelift_role" "role_by_slug" {
  for_each = local.external_role_slugs
  slug     = each.key
}
