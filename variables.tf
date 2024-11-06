variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string
  default     = ""
}

variable "policy_json" {
  description = "An additional policy document as JSON to attach to the Lambda Function role"
  type        = string
  default     = null
}
variable "description" {
  description = "Description of your Lambda Function (or Layer)"
  type        = string
  default     = ""
}

variable "handler" {
  description = "Lambda Function entrypoint in your code"
  type        = string
  default     = ""
}

variable "runtime" {
  description = "Lambda Function runtime"
  type        = string
  default     = ""
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function."
  type        = list(string)
  default     = null
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {}
}
