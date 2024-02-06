provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Define a null_resource to trigger local-exec provisioners
resource "null_resource" "build_and_push" {
  triggers = {
    # Trigger the provisioners whenever the build script changes
   # script_version = filebase64("/home/ec2-user/build.sh")  #in linux
     script_version = filebase64("./build.sh")     # in visual sudio code
  }

  # Use local-exec provisioners to build and push the Docker image
  provisioner "local-exec" {
    command = "docker build -t ${var.DOCKER_USERNAME}/${var.IMAGE_NAME}:latest ."
  }

  # To login the docker hub
  provisioner "local-exec" {
    command = "docker login -u ${var.DOCKER_USERNAME} -p ${var.DOCKER_PASSWORD}"
    # Note: Providing the password directly in the command might not be secure.
    # Consider using other secure methods for credentials.
  }

  # To push image into docker hub
  provisioner "local-exec" {
    command = "docker push ${var.DOCKER_USERNAME}/${var.IMAGE_NAME}:latest"
  }
}
