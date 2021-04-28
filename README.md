# SynBioHub DBLink Plugins


### Authors: Anirudh Watturkar, Sean Nemtzow, Liam Murray, and Rahul Varki

##### Note to see the full repos that are in the proper format for SynBioHub, please see [this for GenBank](https://github.com/helloSeen/Plugin-Visual-GenbankLink) and [this for UniProt](https://github.com/watturkara/Plugin-Visual-UniprotLink)

# Set up
### There are three required setup steps
#### 1. Installing a local SynBioHub Instance
#### 2. Spawning at least two AWS EC2 instances
#### 3. Cloning this directory and installing the dependencies

## Step 1: Installing a local SynBioHub Instance

Please follow the official setup instructions for creating a SynBioHub instance, found [here](https://wiki.synbiohub.org/installation/)

### Summary of steps:
1. [Install docker](https://docs.docker.com/engine/install/)
2. [Install git](https://git-scm.com/downloads)
3. Clone the SynBioHub Docker 

   `git clone https://github.com/synbiohub/synbiohub-docker`
4. Enter the following command to start the instance 

   `docker-compose -f ./synbiohub-docker/docker-compose.yml up`


## Step 2: Spawing the AWS Instances

Please follow the official set up instructions for creating a BLAST + AWS instance, found [here](https://github.com/ncbi/blast_plus_docs#amazon-web-services-setup)

### Summary of steps:
1. Log into AWS and select EC2
2. Select Launch Instance
3. In the AWS Marketplace tab, search  for "Amazon ECS-Optimized Amazon Linux AMI" and click select
4. Choose t2.micro
5. Hit Launch instance
6. Create a networking security group that opens port 80
7. Repeat the above steps for each node you wish to spawn (at least 2)
   
## Step 3: Cloning this Directory and Installing the Dependencies

Please be sure to have python 3.8+ and pip installed before proceeding. These instructions assume a Windows Computer as the local computer and a Linux environment for the AWS EC2 instances.


### UniProt Plugin Setup
1. On your local computer, run 
   
   `git clone https://github.com/watturkara/EC552_Project_DBLink_Plugin.git`
2. Go to the following directory from the root of the repo `Final_Project_SynBioHubDBLinkPlugins/Code/UniProt_Plugin`
3. Run 
    
    `pip install -r requirements.txt`

   * A full list of the required python dependencies is listed there

### GenBank Plugin Setup

#### Datbase Servers (AWS Instances)

**Perform the following for each Database Server**

1. Note the Public IP Address of the instance. This can be found by running

    `curl http://169.254.169.254/latest/meta-data/public-ipv4`

2. Enter `Final_Project_SynBioHubDBLinkPlugins/Code/GenBank_Plugin/` and run 
   
   `git clone https://github.com/watturkara/EC552_Project_DBLink_Plugin.git`

3. Enter `Final_Project_SynBioHubDBLinkPlugins/Code/GenBank_Plugin/` and run
    
    `pip3 install -r requirements.txt`
 
4. Enter `DatabaseServer/`

5. Run the following to get and extract the database (replace $1 with whatever partition of the database you wish to install):
   
    ```
    # Gets necessary packages
    yum install -y git, wget

    pip3 install -r "requirements.txt"

    # Sets up blast directories
    cd $HOME 
    sudo mkdir bin blastdb queries fasta results blastdb_custom

    # Pulls data fragment
    cd blastdb
    wget https://ftp.ncbi.nlm.nih.gov/blast/db/nt.00.tar.gz
    wget "https://ftp.ncbi.nlm.nih.gov/blast/db/nt.{$1}.tar.gz"
    tar -xvf *.tar.gz
    rm *.tar.gz

    echo "Installation complete"

    ```

#### Communication Server (AWS Instance)

1. Note the Public IP Address of the instance. This can be found by running

    `curl http://169.254.169.254/latest/meta-data/public-ipv4`

2. On your AWS instances, run 
   
   `git clone https://github.com/watturkara/EC552_Project_DBLink_Plugin.git`

3. Enter `Final_Project_SynBioHubDBLinkPlugins/Code/GenBank_Plugin/` and run
    
    `pip3 install -r requirements.txt`

4. Enter `CommunicationServer/`

5. Run `pip3 install -r requirements.txt` inside this folder
6. Edit `DBIPs.txt` and put a list of all Database Server Public IP addresses **separated by newlines and nothing else**
7. Edit `Entrez_User_Info.json` and enter your email and Entrez API key (if you have one, otherwise leave as is)
   

#### Plugin server (Local computer)
1. Run 
   
   `git clone https://github.com/watturkara/EC552_Project_DBLink_Plugin.git`

2. `Final_Project_SynBioHubDBLinkPlugins/Code/GenBank_Plugin/` and run 
 
   `pip3 install -r requirements.txt`

3. Enter `PluginServer/`
4. Edit `CommIP.txt` and enter the public IP address of the Communication Server found above


## Running the Plugins

### Adding a New Plugin
1. Log in to your SynBioHub Instance (`http://localhost:7777` by default)
2. Navigate to the admin page and select the Plugin tab
3. Under Rendering, enter a name for the plugin and the URL as 
   
   `http://<server_public_ip4v>:port/`

4. Click Save


### UniProt Plugin
1. In the `UniProt_Plugin/` folder in the repo, run 

    `python3 UniProtBlastMaster.py`
2. On your SynBioHub Instance, add the plugin with your public IPv4 address followed by port 5000 (these are the default settings, if changed this may be different)
   
   ex: `http://192.168.1.1:5000/`

3. Navigate to a protein component in your instance and look for the Plugin's tab
   
### GenBank Plugin

#### Plugin Server

1. In the `GenBank_Plugin/PluginServer/` folder in the repo, run
   
   `python3 plugin_server.py`

#### Communication Server

1. In the `GenBank_Plugin/CommunicationServer/` folder in the repo, run
   
   `python3 comm_server.py`

#### Database Server (Do for each)

1. In the `GenBank_Plugin/DatabaseServer/` folder in the repo, run
   
   `python3 db_server.py`

#### After Doing the Above:
1. On your SynBioHub Instance, add the Plugin Server's IPv4 address followed by port 5050 (these are the default settings, if changed this may be different)
   
   ex: `http://192.168.1.2:5050/`

2. Navigate to a Component in your instance and look for the Plugin's tab