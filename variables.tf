variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "filename" {
  description = "The filename of the Lambda function"
  type        = string
}

variable "timeout" {
  description = "The timeout of the Lambda function"
  type        = number
  
}

variable "memory_size" {
  description = "The memory size of the Lambda function"
  type        = number
  
}