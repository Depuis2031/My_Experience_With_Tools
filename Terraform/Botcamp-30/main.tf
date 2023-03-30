provider "aws" {
   region = us-west-2
}

/*resource "random_integer" "tabe" {
    max = 100
    min = 1
}
*/

resource "random_pet "pet_name" {
  prefix = "bootcamp30"
  length = 3
}

resource "aws_s3-bucket" "backend" {
   count = var.create_vpc ? 1 : 0                           # ? checks if the value is true or false. # 1(can have any number here) means create and 0 means donot create.
  bucket = random_pet.pet_name.id                           #count here is a condition that has to be meet for the bucket to be created and the bucket will be created if a vpc is been created as well.
}

resource "aws_kms_key" "mykey" {
 deletion_window_in_days = 15
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend" {
  bucket = aws_s3_bucket.backend[0].id   #so we add an index number here [0] to refrence the bucket we created and that we will make use of .
  
  rule {
    apply_server_side_encyption_by_default {
      sse_algorithm = "aws:kms" 
      kms_master-key_id = aws_kms_key.mykey.arn
    }
   } 
}

variable "create_vpc" {
   type = bool
   default = true     #this means that bucket will be created if my Vpc is created and then put a conditon if your creating a Vpc
}
