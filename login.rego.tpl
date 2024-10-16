package spacelift

session_key := ${session_key}

## Admin Section
admin_whitelist := {
  %{ for admin in admins ~}
  "${admin}",
  %{ endfor ~}
}
admin {
 admin_whitelist[session_key]
}

%{ for space_key, space_value in spaces ~}
## ${space_key} Section

%{ if length(lookup(space_value, "admin", [])) > 0 ~}
# Admin access
${space_key}_admin := {
  %{ for user in space_value.admin ~}
  "${user}",
  %{ endfor ~}
}
space_admin["${space_value.space_id}"] {
  ${space_key}_admin[session_key]
}
%{ endif ~}

%{ if length(lookup(space_value, "write", [])) > 0 ~}
# Write access
${space_key}_write := {
  %{ for user in space_value.write ~}
    "${user}",
  %{ endfor ~}
}
space_write["${space_value.space_id}"] {
  ${space_key}_write[session_key]
}
%{ endif ~}

%{ if length(lookup(space_value, "read", [])) > 0 ~}
# Read access
${space_key}_read := {
  %{ for user in space_value.read ~}
  "${user}",
  %{ endfor ~}
}
space_read["${space_value.space_id}"] {
  ${space_key}_read[session_key]
}
%{ endif ~}

# Allow the access level defined above
%{ if length(lookup(space_value, "admin", [])) > 0 ~}
allow {
  ${space_key}_admin[session_key]
}
%{ endif ~}
%{ if length(lookup(space_value, "write", [])) > 0 ~}
allow {
  ${space_key}_write[session_key]
}
%{ endif ~}
%{ if length(lookup(space_value, "read", [])) > 0 ~}
allow {
  ${space_key}_read[session_key]
}
%{ endif ~}

%{ endfor ~}


sample{ true }
