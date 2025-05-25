terraform {
  backend "s3" {
    bucket       = "my-tfstate-bucket-45"
    key          = "otel-app/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
