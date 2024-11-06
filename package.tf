variable "artifacts_dir" {
  description = "Directory name where artifacts should be stored"
  type        = string
  default     = "builds"
}

variable "source_path" {
  description = "The absolute path to a local file or directory containing your Lambda source code"
  type        = string
  default     = null
}

locals {
  python = (substr(pathexpand("~"), 0, 1) == "/") ? "python3" : "python.exe"
}

# Generates a filename for the zip archive based on the content of the files
# in source_path. The filename will change when the source code changes.
data "external" "archive_prepare" {
  program = [local.python, "${path.module}/package.py", "prepare"]

  query = {
    paths = jsonencode({
      module = path.module
      root   = path.root
      cwd    = path.cwd
    })

    artifacts_dir            = var.artifacts_dir
    runtime                  = var.runtime
    source_path              = jsonencode(var.source_path)
    hash_extra               = ""
    hash_extra_paths         = jsonencode([])
    recreate_missing_package = true
  }
}

# This transitive resource used as a bridge between a state stored
# in a Terraform plan and a call of a build command on the apply stage
# to transfer a noticeable amount of data
resource "local_file" "archive_plan" {
  content              = data.external.archive_prepare.result.build_plan
  filename             = data.external.archive_prepare.result.build_plan_filename
  directory_permission = "0755"
  file_permission      = "0644"
}

# Build the zip archive whenever the filename changes.
resource "null_resource" "archive" {
  triggers = {
    filename = data.external.archive_prepare.result.filename
  }

  provisioner "local-exec" {
    interpreter = [
      local.python, "${path.module}/package.py", "build",
      "--timestamp", data.external.archive_prepare.result.timestamp
    ]
    command = data.external.archive_prepare.result.build_plan_filename
  }

  depends_on = [local_file.archive_plan]
}
