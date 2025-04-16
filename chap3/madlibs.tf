// Terraform block
terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

// Object for word pool
variable "words" {
  description = "A word pool to use for Mad Libs"
  type = object({
    nouns = list(string),
    adjectives = list(string),
    adverbs = list(string),
    verbs = list(string),
    numbers = list(number)
  })

  validation {
    condition = length(var.words["nouns"]) >= 20
    error_message = "At least 20 nouns are required."
  }
}

// Shuffle all lists using the random resource
resource "random_shuffle" "random_nouns" {
  input = var.words["nouns"]
}

resource "random_shuffle" "random_verbs" {
  input = var.words["verbs"]
}

resource "random_shuffle" "random_adverbs" {
  input = var.words["adverbs"]
}

resource "random_shuffle" "random_adjectives" {
  input = var.words["adjectives"]
}

resource "random_shuffle" "random_numbers" {
  input = var.words["numbers"]
}