terraform {
 backend "gcs" {
   bucket  = "dkatalis-bucket-tfstate"
   prefix  = "terraform/state"
 }
}
