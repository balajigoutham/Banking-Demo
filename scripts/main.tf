resource "aws_instance" "test-server" {
  ami           = "ami-00ac45f3035ff009e" 
  instance_type = "t2.micro" 
  key_name = "jenkins"
  vpc_security_group_ids= ["sg-06e7a45a6786ad282"]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("./jenkins.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server.public_ip} > inventory "
  }
   provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/Banking/scripts/finance-playbook.yml "
  } 
}
