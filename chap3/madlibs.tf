variable "words" {
  description = "A word pool to use for Mad Libs"
  type = object({
    nouns = list(string),
    adjectives = list(string),
    adverbs = list(string),
    verbs = list(string),
    numbers = list(number)
  })
}