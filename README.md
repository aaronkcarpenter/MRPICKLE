# MRPICKLE

**M**anage
**R**oles (and)
**P**olicies
**I**ncredibly
**C**onveniently
**K**eeping
**L**ogins
**E**fficient

## What?

This module is designed to generate login policies inside Spacelift that are convenient and simple.
Stop worrying about how to grand folks access to your Spacelift organization and let MRPICKLE do it for you.

Heres a simple example of how to use this module:

```hcl
resource "spacelift_space" "billys" {
  name            = "billys-space"
  description     = "only billy can access this"
  parent_space_id = "root"
}

resource "spacelift_space" "johnnys" {
  name            = "johnnys-space"
  description     = "only johnny can access this"
  parent_space_id = "root"
}

resource "spacelift_space" "billy_and_johnnys" {
  name            = "billy-and-johnnys-space"
  description     = "billy and johnny can access this, but only billy is an admin"
  parent_space_id = "root"
}

module "mrpickle" {
  source = "github.com/apollorion/mrpickle"

  admins = [
    "Apollorion"
  ]

  spaces = {
    BILLYS_SPACE = {
      space_id = spacelift_space.billys.id
      admin    = ["Billy"]
    }
    JOHNNYS_SPACE = {
      space_id = spacelift_space.johnnys.id
      admin    = ["Johnny"]
    }
    BILLY_AND_JOHNNYS_SPACE = {
      space_id = spacelift_space.billy_and_johnnys.id
      admin    = ["Billy"]
      write    = ["Johnny"]
      read     = ["Peter"]
    }
  }
}
```

This will create the necessary login policy that will grant access as you specify in terraform.


## Inputs

| Name                                                                 | Description                         | Type                                                                                                                                                                                      | Default                              | Required |
|----------------------------------------------------------------------|-------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------|:--------:|
| <a name="input_admins"></a> [admins](#input\_admins)                 | List of global admins               | `list(string)`                                                                                                                                                                            | `[]`                                 |    no    |
| <a name="input_description"></a> [description](#input\_description)  | Description of the policy           | `string`                                                                                                                                                                                  | `"MRPICKLES generated login policy"` |    no    |
| <a name="input_lables"></a> [lables](#input\_lables)                 | labels to add to the login policy   | `list(string)`                                                                                                                                                                            | `null`                               |    no    |
| <a name="input_name"></a> [name](#input\_name)                       | Name of the policy                  | `string`                                                                                                                                                                                  | `"MRPICKLES"`                        |    no    |
| <a name="input_session_key"></a> [session_key](#input\_session\_key) | Session key for the policy          | `string`                                                                                                                                                                                  | `"input.session.login"`              |    no    |
| <a name="input_spaces"></a> [spaces](#input\_spaces)                 | Map of spaces and their permissions | <pre>map(object({<br/>    space_id = string<br/>    admin    = optional(list(string))<br/>    write    = optional(list(string))<br/>    read     = optional(list(string))<br/>  }))</pre> | `{}`                                 |    no    |

What is the `session_key`? Spacelift can do comparisons against a multitude of different data points to determine if a user should be granted access.
The `session_key` is the data point that will be used to determine if a user should be granted access.
By default it uses the `input.session.login` which is the username of the user logging in. So the admins, writers, and reader inputs of this module should be the username of the user logging in.
If the session key was something else, like a group maybe. You would set the `session_key` to that group and the admins, writers, and readers would be the group name.