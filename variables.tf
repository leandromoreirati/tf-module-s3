variable name {
  type        = string
  default     = ""
  description = "Bucket S3 name."
}

/* ACl types: https://docs.aws.amazon.com/pt_br/AmazonS3/latest/dev/acl-overview.html#canned-acl */
variable acl {
  type        = string
  default     = "private"
  description = "Defines which type of bucket access acl S3 (public or privite). "
}

variable create_object {
  type        = bool
  default     = false
  description = "Enables bucket object creation (true or false)."
}

variable "object_key" {
  type        = string
  default     = ""
  description = "The name of the object once it is in the bucket."
}

variable object_source {
  type        = string
  default     = ""
  description = "Path to a file that will be read and uploaded as raw bytes for the object content."
}

variable tags {
  type        = map(string)
  default     = {}
  description = "Map os tags."
}

variable versioning {
  type        = list
  default     = []
  description = "Versioning object into bucket (true or false)."
}

variable force_destroy {
  default     = false
  description = "Indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error"
}

variable logging {
  type        = list
  default     = []
  description = "Enable logging set this to [{target_bucket = 'xxx' target_prefix = 'logs/'}]"
}

variable lifecycle_rule {
  type        = list
  default     = []
  description = "Enable or disable lifecycle rules dynamic block configuration."
}

variable transition {
  type        = list
  default     = []
  description = "Enable or disable lifecycle transition rules dynamic block configuration."
}

variable expiration {
  type        = list
  default     = []
  description = "Enable or disable lifecycle expiration rules dynamic block configuration."
}

variable "noncurrent_version_transition" {
  type        = list
  default     = []
  description = "Enable or disable lifecycle noncurrent version transitcion rules dynamic block configuration."
}

variable "noncurrent_version_expiration" {
  type        = list
  default     = []
  description = "Enable or disable lifecycle noncurrent version expiration rules dynamic block configuration."
}

variable "server_side_encryption_configuration" {
  type        = list
  default     = []
  description = "Enable or disable lifecycle noncurrent version expiration rules dynamic block configuration."
}

variable upload {
  type        = string
  default     = ""
  description = "Folder to upload. Do no upload empty folder."
}

/* BUCKET BLOCK PUBLIC ACCESS */
variable bucket {
  type        = string
  default     = ""
  description = "The name of the bucket to which to apply the policy."
}

variable create_public_access_block {
  type        = bool
  default     = true
  description = "Enable blocking public access to the bucket."
}

variable block_public_acls {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should block public ACLs for this bucket."
}

variable block_public_policy {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
}

variable ignore_public_acls {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
}

variable restrict_public_buckets {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
}

/* BUCKET NOTIFICATION */
variable create_notification {
  type        = bool
  default     = false
  description = "Enable blocking public access to the bucket."
}

variable topic {
  type        = map(string)
  default     = {}
  description = "string of topic rules."
}

variable queue {
  type        = map(string)
  default     = {}
  description = "string of queur rules."
}

variable lambda {
  type        = map(string)
  default     = {}
  description = "string of queur rules."
}

/* BUCKET POLICY */
variable create_bucket_policy {
  type        = bool
  default     = false
  description = "Enable bucket policy."
}

variable policy {
  type        = string
  default     = ""
  description = "The text of the policy."
}
