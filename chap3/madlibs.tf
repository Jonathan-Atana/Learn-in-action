// Terraform block
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

// Object for word pool
variable "words" {
  description = "A word pool to use for Mad Libs"
  type = object({
    nouns      = list(string),
    adjectives = list(string),
    adverbs    = list(string),
    verbs      = list(string),
    numbers    = list(number)
  })

  validation {
    condition     = length(var.words["nouns"]) >= 12
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

// Output variable to display the Mad Libs
output "mad_libs" {
  description = "Display Mad Libs stories using the templatefile function"
  value = templatefile(
    "${path.module}/templates/alice.txt",
    {
      nouns      = random_shuffle.random_nouns.result
      verbs      = random_shuffle.random_adjectives.result
      adverbs    = random_shuffle.random_adverbs.result
      adjectives = random_shuffle.random_adjectives.result
      numbers    = random_shuffle.random_numbers.result
    }
  )
}