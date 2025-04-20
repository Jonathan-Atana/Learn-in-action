# Terraform block
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

# Resource block
resource "random_shuffle" "random_nouns" { // Shuffle all lists using the random resource
  count = var.num_files                    // create 'var.num_files' number of resources
  input = local.uppercase_words["nouns"]
}

resource "random_shuffle" "random_verbs" {
  count = var.num_files
  input = local.uppercase_words["verbs"]
}

resource "random_shuffle" "random_adverbs" {
  count = var.num_files
  input = local.uppercase_words["adverbs"]
}

resource "random_shuffle" "random_adjectives" {
  count = var.num_files
  input = local.uppercase_words["adjectives"]
}

resource "random_shuffle" "random_numbers" {
  count = var.num_files
  input = local.uppercase_words["numbers"]
}

resource "local_file" "mad_libs" { // local files for mad libs stories
  count    = var.num_files
  filename = "madlibs/madlibs-${count.index}.txt" // filenames based on the count index
  content = templatefile(
    element(local.templates, count.index),
    {
      nouns      = random_shuffle.random_nouns[count.index].result
      verbs      = random_shuffle.random_adjectives[count.index].result
      adverbs    = random_shuffle.random_adverbs[count.index].result
      adjectives = random_shuffle.random_adjectives[count.index].result
      numbers    = random_shuffle.random_numbers[count.index].result
    }
  )
}

# Data sources
data "archive_file" "mad_libs" {      // Archive file to create a zip file of the mad libs files in madlibs folder
  depends_on  = [local_file.mad_libs] // archive_file must be evaluated after all madlibs files are created
  type        = "zip"
  source_dir  = "${path.module}/madlibs"
  output_path = "${path.cwd}/madlibs.zip"
}

# Locals block
locals {
  # Name the expression to render all words uppercase (using locals)
  uppercase_words = {
    for key, values in var.words : key => [
      for item in values : upper(item)
    ]
  }
}

locals {
  # get a list of all files names in the templates folder
  templates = tolist(
    fileset(
      path.module,
      "templates/*.txt"
    )
  )
}

# Input  variables
variable "words" { // Object for word pool
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
    error_message = "At least 12 nouns are required."
  }
}

variable "num_files" { // number of resources to create using count
  description = "Number of resources to create"
  type        = number
  default     = 100

}