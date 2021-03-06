![alt text](https://www.terraform.io/assets/images/logo-hashicorp-3f10732f.svg)

# **tf-module-bucket**

Supported Resources:

* [S3 Bucket](https://www.terraform.io/docs/providers/aws/r/s3_bucket.html)
* [S3 Bucket Object](https://www.terraform.io/docs/providers/aws/r/s3_bucket_object.html)
* [S3 Bucket Notification](https://www.terraform.io/docs/providers/aws/r/s3_bucket_object.html)
* [S3 Bucket Policy](https://www.terraform.io/docs/providers/aws/r/s3_bucket_object.html)

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |
| terraform | ~> 0.12.0 |

## Features
Create resources in S3 such `bucket`, `buckets objects`, objects created in the bucket can be from files and directory structures, `notifications` and bucket policies, making them available for use by `instances` or another resource that makes use of `storage`.

For all configurations involving policies and roles, a directory should be created at the root of the project to organize these files, by default for roles a directory called role called a policy for policies.

## Requirements
  - Terraform
  - AWS Account
  
## Dependencies
  - Not applicable.

## Example of Use
 ------
`bucket`:

```hcl
module "bucket" {
  source = "git@github.com:leandromoreirati/tf-module-s3.git"

  name = "bucket-test"

  versioning = [
    {
      enabled = true
    }
  ]

  tags = {
    Name        = "bucket-test"
    Terraform   = "true"
  }
}
```

`Bucket with upload folder and files.`:

```hcl
module "bucket" {
  source = "git@github.com:leandromoreirati/tf-module-s3.git"

  bucket_name = "bucket-test"
  
  upload = "frutas/"
  
  tags = {
    Name           = "bucket-test"
    Terraform      = "true"
  }
}
```

`Lifecycle on Bucket` :

```hcl
module "bucket" {
  source = "git@github.com:leandromoreirati/tf-module-s3.git"

  bucket = module.bucket.bucket_id
  acl  = "private"

  versioning = [
    {
    enabled = true
    }
  ]

  lifecycle_rule = [
    {
      id                                     = module.s3_label.id
      enabled                                = true
    }
  ]

  noncurrent_version_transition = [
    {
      days = 30
      storage_class = "STANDARD_IA"
    },
    {
      days = 60
      storage_class = "GLACIER"
    }
  ]

  tags = {
    Name        = "${var.my_team}-${var.product}-backup-${var.environment}"
    environment = var.environment
    Terraform   = "true"
  }
}
```

`Notification on SNS Topic` :

```hcl
module "notification" {
  source = "git@github.com:leandromoreirati/tf-module-s3.git"

  bucket = module.bucket.bucket_id
  topic_rules = [{
      topic_arn     = aws_sns_topic.topic.arn
      events        = "s3:ObjectCreated:*"
      filter_suffix = ".log"
  }]
}
```

`Notification on SQS Queue` :

```hcl
module "notification" {
  source = "git@github.com:leandromoreirati/tf-module-s3.git"

  bucket = module.bucket.bucket_id
  queue_rules = [{
      queue_arn     = aws_sqs_queue.queue.arn
      events        = "s3:ObjectCreated:*"
      filter_suffix = ".log"
  }]
}
```

`Notification on Function` :

```hcl
module "notification" {
  source = "git@github.com:leandromoreirati/tf-module-s3.git"

  bucket = module.bucket.bucket_id
  lambda_rules = [{
      lambda_function_arn     = aws_lambda_function.func.ar
      events                  = "s3:ObjectCreated:*"
      filter_prefix           = "lAWSLogs/"
      filter_suffix           = ".log"
  }]
}

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acl | Defines which type of bucket access acl S3 (public or privite). | `string` | `"private"` | no |
| block\_public\_acls | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `true` | no |
| block\_public\_policy | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| bucket | The name of the bucket to which to apply the policy. | `string` | `""` | no |
| create\_bucket\_policy | Enable bucket policy. | `bool` | `false` | no |
| create\_notification | Enable blocking public access to the bucket. | `bool` | `false` | no |
| create\_object | Enables bucket object creation (true or false). | `bool` | `false` | no |
| create\_public\_access\_block | Enable blocking public access to the bucket. | `bool` | `true` | no |
| expiration | Enable or disable lifecycle expiration rules dynamic block configuration. | `list` | `[]` | no |
| force\_destroy | Indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error | `bool` | `false` | no |
| ignore\_public\_acls | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| lambda | string of queur rules. | `map(string)` | `{}` | no |
| lifecycle\_rule | Enable or disable lifecycle rules dynamic block configuration. | `list` | `[]` | no |
| logging | Enable logging set this to [{target\_bucket = 'xxx' target\_prefix = 'logs/'}] | `list` | `[]` | no |
| name | Bucket S3 name. | `string` | `""` | no |
| noncurrent\_version\_expiration | Enable or disable lifecycle noncurrent version expiration rules dynamic block configuration. | `list` | `[]` | no |
| noncurrent\_version\_transition | Enable or disable lifecycle noncurrent version transitcion rules dynamic block configuration. | `list` | `[]` | no |
| object\_key | The name of the object once it is in the bucket. | `string` | `""` | no |
| object\_source | Path to a file that will be read and uploaded as raw bytes for the object content. | `string` | `""` | no |
| policy | The text of the policy. | `string` | `""` | no |
| queue | string of queur rules. | `map(string)` | `{}` | no |
| restrict\_public\_buckets | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `true` | no |
| tags | Map os tags. | `map(string)` | `{}` | no |
| topic | string of topic rules. | `map(string)` | `{}` | no |
| transition | Enable or disable lifecycle transition rules dynamic block configuration. | `list` | `[]` | no |
| upload | Folder to upload. Do no upload empty folder. | `string` | `""` | no |
| versioning | Versioning object into bucket (true or false). | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of the bucket. |
| block | Name of the S3 bucket the configuration is attached. |
| bucket\_notification\_id | Unique identifier for each of the notification configurations. |
| bucket\_policy | The text of the policy. |
| bucket\_policy\_name | The name of the bucket to which to apply the policy. |
| id | ID of the bucket. |
| name | Name of the bucket. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# External Documentation
 - [Amazon S3](https://amzn.to/38CEDNo)
 - [Amazon S3 Bucket Object](https://amzn.to/37Eclka)
 - [Amazon S3 Bucket Policy](https://amzn.to/33jDdFL)

# Created Features
 ------
 - Amazon S3
 - Amazon S3 Bucket Object (filan or folders)
 - Amazon S3 Bucket Policy