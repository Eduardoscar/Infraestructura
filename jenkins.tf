resource "docker_image" "jenkins_docker" {
  name = "eduardo_jenkins"
  build {
    path = "./jenkins-docker"
    tag = [
      "eduardo_jenkins:latest"
    ]
  }
}

resource "docker_volume" "jenkins_volume_dos" {
  name = "jenkins_home_dos"
}

resource "docker_container" "jenkins_eduardo" {
  name       = "jenkins_eduardo"
  image      = docker_image.jenkins_docker.image_id
  privileged = true
  env = [
    "JENKINS_HOME_DOS=/var/jenkins_home_dos",
  ]
  ports {
    internal = 8080
    external = 8081
  }
  volumes {
    host_path      = "//var/run/docker.sock"
    container_path = "/var/run/docker.sock"
    read_only      = false
  }
  volumes {
    volume_name    = "jenkins_home_dos"
    host_path      = "C:/Users/eduar/Documents/jenkins_home_dos"
    container_path = "/var/jenkins_home_dos"
    read_only      = false
  }
  provisioner "local-exec" {
    command = "docker exec -d -u root jenkins_eduardo chown jenkins_eduardo:jenkins_eduardo /var/run/docker.sock"
  }
}

output "jenkins_ip" { value = "JENKINS_IP=${docker_container.jenkins_eduardo.ip_address}" }