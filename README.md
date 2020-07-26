#  "Ultimate AWS Certified Cloud Practitioner" course Terraform configuration

This is a Terraform (0.12) configuration I've created in order to exercise the Udemy course ["Ultimate AWS Certified Cloud Practitioner"](https://www.udemy.com/course/aws-certified-cloud-practitioner-new) that I've taken, while also practicing Terraform.

All the related resources have been created, with minor but not substantial changes. Also, since the primary focus was AWS, for simplicity, the Terraform configuration is purely declarative (e.g. no cycles).

The Terraform (resource) notes I've take, which adds some minor details, are [stored separately](https://github.com/saveriomiroddi/personal_notes/blob/master/terraform.md) in my `personal_notes` project.

## Applying the configuration

While the configuration is complete, it can't be applied straight away, due to the circular problem that in order to create the sysadmin's user/key/permissions, they need to be existing already.

This is standard workflow - just create the required objects via console, then import them.
