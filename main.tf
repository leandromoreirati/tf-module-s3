/* For more details on the configuration, visit the official documentation::
    https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
    https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
    https://www.terraform.io/docs/providers/aws/r/s3_bucket_notification.html
    https://www.terraform.io/docs/providers/aws/r/s3_bucket_object.html
    https://www.terraform.io/docs/providers/aws/r/s3_bucket_policy.html
 */

#tfsec:ignore:AWS002 tfsec:ignore:AWS017
resource "aws_kms_key" "default" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "default" {
  bucket = var.name
  acl    = var.acl

  dynamic "versioning" {
    for_each = var.versioning

    content {
      enabled    = lookup(versioning.value, "enabled", null)
      mfa_delete = lookup(versioning.value, "mfa_delete", null)
    }
  }

  force_destroy = var.force_destroy

  dynamic "logging" {
    for_each = var.logging
    content {
      target_bucket = lookup(logging.value, "target_bucket", null)
      target_prefix = lookup(logging.value, "target_prefix", null)
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule
    content {
      id                                     = lookup(lifecycle_rule.value, "id", null)
      enabled                                = lookup(lifecycle_rule.value, "enabled", null)
      prefix                                 = lookup(lifecycle_rule.value, "prefix", null)
      abort_incomplete_multipart_upload_days = lookup(lifecycle_rule.value, "abort_incomplete_multipart_upload_days", null)

      /* TRANSITION */
      dynamic "transition" {
        for_each = var.transition
        content {
          date          = lookup(noncurrent_version_transition.value, "date", null)
          days          = lookup(noncurrent_version_transition.value, "days", null)
          storage_class = lookup(noncurrent_version_transition.value, "storage_class", null)
        }
      }

      /* EXPIRATION */
      dynamic "expiration" {
        for_each = var.expiration
        content {
          date                         = lookup(noncurrent_version_transition.value, "date", null)
          days                         = lookup(noncurrent_version_transition.value, "days", null)
          expired_object_delete_marker = lookup(noncurrent_version_transition.value, "expired_object_delete_marker", null)
        }
      }

      /* NONCURRENT VERSION TRANSITION */
      dynamic "noncurrent_version_transition" {
        for_each = var.noncurrent_version_transition
        content {
          days          = lookup(noncurrent_version_transition.value, "days", null)
          storage_class = lookup(noncurrent_version_transition.value, "storage_class", null)
        }
      }

      /* NONCURRENT VERSION EXPIRATION */
      dynamic "noncurrent_version_expiration" {
        for_each = var.noncurrent_version_expiration
        content {
          days = lookup(noncurrent_version_expiration.value, "days", null)
        }
      }
    }
  }

   dynamic "server_side_encryption_configuration" {
   for_each = var.server_side_encryption_configuration
   content {
     rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.default.arn
        sse_algorithm     = lookup(server_side_encryption_configuration.value, "days", "aws:kms")
       }
     }
    }
   }

  tags = var.tags
}

/* BLOCK PUBLIC ACCESS */
resource "aws_s3_bucket_public_access_block" "default" {
  count = var.create_public_access_block ? 1 : 0

  bucket                  = aws_s3_bucket.default.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

/* BUCKET NOTIFICATION */
resource "aws_s3_bucket_notification" "default" {
  count = var.create_notification ? 1 : 0

  bucket = var.bucket

  dynamic "topic" {
    for_each = var.topic
    content {
      topic_arn     = lookup(topic.value, "topic_arn", null)
      events        = lookup(topic.value, "events", null)
      filter_suffix = lookup(topic.value, "filter_suffix", null)
    }
  }

  dynamic "queue" {
    for_each = var.queue
    content {
      queue_arn     = lookup(queue.value, "queue_arn", null)
      events        = lookup(queue.value, "events", null)
      filter_suffix = lookup(queue.value, "filter_suffix", null)
    }
  }

  dynamic "lambda_function" {
    for_each = var.lambda
    content {
      lambda_function_arn = lookup(lambda.value, "lambda_function_arn", null)
      events              = lookup(lambda.value, "events", null)
      filter_prefix       = lookup(lambda.value, "filter_prefix", null)
      filter_suffix       = lookup(lambda.value, "filter_suffix", null)
    }
  }
}

/* BUCKET POLICY */
resource "aws_s3_bucket_policy" "default" {
  count  = var.create_bucket_policy ? 1 : 0
  bucket = var.name
  policy = var.policy
}
