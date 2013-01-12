chef_sudo_user
==============
create user that login in by ssh key, and can run sudo without password.

Install: 

1. install ec2 api tool. 
2. install chef 
3. install knife_solo 
4. open config.sh, config it based on your environment.


Script files:

1. ec2_create_instance.sh 
    Create a ec2 instance by ec2 api tool, and will create a user named "focus" on new instance, 
    you should login to server by focus user. The login process is too simple, just input below command:

    #  ssh focus@YOUR_INSTANCE_PUBLIC_DNS

2. ec2_prepare.sh 
    shurtcut for knife prepare.

3. ec2_cook.sh 
    shurtcut for knife cook



Nodes/*.json :

1. default.json 
    This file will be used to default running list to node, if you want to change the running list for special
    node, I recommend  you cope the default.json to your special node's json, and change the content in your 
    node's json directly. 

2. user.json 
    Just ignore it if you don't have new requirements for user installation.
