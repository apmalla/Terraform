#jenkins slave

resource "aws_instance" "JenkinsSlave" {
  count = "${var.jenkinsslave_count}"

  connection {
    user        = "ubuntu"
    private_key = "${file(var.private_key_path)}"
  }

  /*user_data = "${template_file.userdata.rendered}"*/

  instance_type          = "${var.instance_type}"
  ami                    = "${lookup(var.aws_amis, var.aws_region)}"
  key_name               = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.jenkins_slave.id}"]
  subnet_id              = "${aws_subnet.default.id}"
  tags {
    Name = "MGMT_TOOLING_JENKINS_SLAVE_TERRAFROM"
  }

  provisioner "remote-exec" {
    inline = [
      # Remove hardcoded IP with chef_server_public_ip
      "sudo sh -c \"echo ${var.chef_server_public_ip} chefserver >> /etc/hosts\"",

      "sudo apt-get update -y",
    ]

    # "sudo sh -c \" ${var.chef_server_entry_hosts} \"",
  }
#  provisioner "chef" {
#    environment = "${var.chef_env_name}"

#    fetch_chef_certificates = "true"

    #Todo: use chef cookbook to update sudoers file
    # run_list = ["java::oracle", "git::default", "docker::default", "awscli::default", "sudoers" ]
#    run_list = ["maven::default"]

#    node_name = "JenkinsSlave"

    /*secret_key = "${file("../encrypted_data_bag_secret")}"*/

#    server_url      = "https://${var.chef_server_name}/organizations/${var.chef_organization_name}"
#    recreate_client = true
#    user_name       = "${var.chef_user_name}"
#    user_key        = "${file(var.chef_admin_key_path)}"
#    version         = "${var.chef_version}"
#  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get install -y python-software-properties debconf-utils",
      "sudo add-apt-repository -y ppa:webupd8team/java",
      "sudo apt-get update",
      "echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 select true' | sudo debconf-set-selections",
      "sudo apt-get install -y oracle-java8-installer",

      # Configure awscli
      "sudo apt-get install python2.7 -y",

      "curl -O https://bootstrap.pypa.io/get-pip.py",
      "sudo python2.7 get-pip.py",
      "rm get-pip.py",
      "sudo pip install awscli",

      # Configure docker git
      "sudo apt-get install apt-transport-https ca-certificates -y",

      "sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D -y",
      "echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' | sudo tee /etc/apt/sources.list.d/docker.list",
      "sudo apt-get update",
      "sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual -y",
      "sudo apt-get install docker-engine -y",
      "sudo service docker start",

      #git
      "sudo apt-get install git -y",

      #Needed for upstream push
      "sudo apt-get install csh -y",

      #Configure with jenkins
      #TODO:
      # "sudo -s jenkins aws configure set aws_access_key_id ${var.jenkinsslave_aws_ecr_access_key}",
      # "sudo -s jenkins aws configure set aws_secret_access_key ${var.jenkinsslave_aws_ecr_secret_key}",
      # "sudo -s jenkins aws configure set default.region ${var.aws_region}",      
      "aws configure set aws_access_key_id ${var.jenkinsslave_aws_ecr_access_key}",

      "aws configure set aws_secret_access_key ${var.jenkinsslave_aws_ecr_secret_key}",
      "aws configure set default.region ${var.aws_region}",
    ]

    # Configure java::oracle::8
  }

  #   provisioner "remote-exec" {

  #   inline = [

  #     # Configure jenkins slave to talk to master

  #     "sudo apt-get update",

  #     "sudo wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/2.1/swarm-client-2.1-jar-with-dependencies.jar",

  #     "sudo java -s jenkins -Xmx256m -jar swarm-client-2.1-jar-with-dependencies.jar -master http://${aws_instance.JenkinsMaster.private_ip}:${var.jenkinsmaster_port} -executors 2 -username admin -password admin -name slave1 &> swarm.log &",

  #   ]

  # }

  # provisioner "remote-exec" {

  #   inline = [

  #     # Configure maven3

  #     "sudo apt-get purge -y maven",

  #     "wget http://redrockdigimark.com/apachemirror/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz",

  #     "tar -zxf apache-maven-3.3.9-bin.tar.gz",

  #     "sudo cp -R apache-maven-3.3.9 /usr/local",

  #     "sudo ln -s /usr/local/apache-maven-3.3.9/bin/mvn /usr/bin/mvn",

  #     "echo 'export M2_HOME=/usr/local/apache-maven-3.3.9' >> ~/.profile",

  #     "source ~/.profile",

  #   ]

  # }

  # attributes_json = <<-EOF

  # {

  # "java": {

  #   "install_flavor": "oracle_rpm",

  #   "jdk_version": "7",

  #   "oracle": {

  #     "accept_oracle_download_terms": true

  #   }

  # },

  #   "recipe[java]"

  # ]

  # }

  # EOF
}
