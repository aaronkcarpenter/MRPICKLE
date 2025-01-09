variable "admins" {
  type        = list(string)
  description = "List of global admins"
  default     = []
}

variable "spaces" {
  type = map(object({
    space_id = string
    admin    = optional(list(string))
    write    = optional(list(string))
    read     = optional(list(string))
  }))
  description = "Map of spaces and their permissions"
  default     = {}
}

variable "name" {
  type        = string
  description = "Name of the policy"
  default     = "MRPICKLES"
}

variable "description" {
  type        = string
  description = "Description of the policy"
  default     = "MRPICKLES generated login policy"
}

variable "labels" {
  type        = list(string)
  description = "labels to add to the login policy"
  default     = null
}

variable "session_key" {
  type        = string
  description = "Session key for the policy"
  default     = "input.session.login"
}

locals {
  # Just remove the null values from the permissions
  spaces = {
    for space, permissions in var.spaces : space => {
      space_id = permissions.space_id
      admin    = permissions.admin != null ? permissions.admin : []
      write    = permissions.write != null ? permissions.write : []
      read     = permissions.read != null ? permissions.read : []
    }
  }
}

resource "spacelift_policy" "this" {
  type        = "LOGIN"
  name        = var.name
  description = var.description
  labels      = var.labels

  body = templatefile("${path.module}/login.rego.tpl", {
    admins      = var.admins
    spaces      = local.spaces
    session_key = var.session_key
  })
}
