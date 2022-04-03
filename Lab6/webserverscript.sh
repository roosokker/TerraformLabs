#!/bin/bash
sudo yum install httpd
sudo systemctl enable httpd
sudo systemctl start httpd
# sudo cp /home/ec2-user/webApp.php /var/www/html