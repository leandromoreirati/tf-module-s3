/* BUCKET */
output "id" {
  value       = aws_s3_bucket.default.id
  description = "ID of the bucket."
}

output "arn" {
  value       = aws_s3_bucket.default.arn
  description = "ARN of the bucket."
}

output "name" {
  value       = aws_s3_bucket.default.bucket
  description = "Name of the bucket."
}

/* BUCKET BLOCK PUBLIC ACCESS */
output "block" {
  value       = aws_s3_bucket_public_access_block.default.*.id
  description = "Name of the S3 bucket the configuration is attached."
}

/* BUCKET NOTIFICATION */
output "bucket_notification_id" {
  value       = aws_s3_bucket_notification.default.*.id
  description = "Unique identifier for each of the notification configurations."
}

/* BUCKET OBJECT */
/* output "bucket_object_id" {
  value       = aws_s3_bucket_object.default.*.id
  description = "Key of the resource supplied above."
}

output "etag" {
  value       = aws_s3_bucket_object.default.*.etag
  description = "E-Tag generated for the object (an MD5 sum of the object content)."
} */

/* BUCKET POLICY */
output "bucket_policy_name" {
  value       = aws_s3_bucket_policy.default.*.bucket
  description = "The name of the bucket to which to apply the policy."
}

output "bucket_policy" {
  value       = aws_s3_bucket_policy.default.*.policy
  description = "The text of the policy."
}