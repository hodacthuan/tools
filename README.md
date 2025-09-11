# Step by step for new device installed
```
google chrome
terminator
cursor ai
aws cli
docker
docker-compose
kubectl
minikube
lens
mdatp
opswat-client
add ssh-key
init-mdaas-project
    clone 3 repos
    add .env file to local-repos
    sm-start
    build image
    up
```




# Install commons tools
```sh

sudo apt update

# Install redis-cli
redis-cli --version >/dev/null 2>&1
[[ $? != 0 ]] && sudo apt-get install redis-tools -y

BEEKEEPER="$(apt-cache policy beekeeper-studio)"
if [[ $BEEKEEPER == '' ]]; then 
    echo "Install beekeeper-studio"
    wget --quiet -O - https://deb.beekeeperstudio.io/beekeeper.key | sudo apt-key add -
    echo "deb https://deb.beekeeperstudio.io stable main" | sudo tee /etc/apt/sources.list.d/beekeeper-studio-app.list
    sudo apt update
    sudo apt install -y beekeeper-studio
fi

TELEGRAM="$(apt-cache policy telegram)"
if [[ $TELEGRAM == '' ]]; then 
    echo "Install telegram"
    sudo add-apt-repository ppa:atareao/telegram
    sudo apt update
    sudo apt install -y telegram
fi

BAMBOO="$(apt-cache policy ibus-bamboo)"
if [[ $BAMBOO == '' ]]; then
    echo "Install ibus-bamboo"
    sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo
    sudo apt install -y ibus ibus-bamboo
fi

TERMINATOR="$(apt-cache policy terminator)"
if [[ $TERMINATOR == '' ]]; then 

    sudo apt update
    sudo apt install -y timeshift git curl terminator git-flow htop golang nodejs npm jq --install-recommends
    sudo snap install postman
    sudo npm i -g eslint@3.19.0 eslint-plugin-security
fi


AWS=$(which aws)
if [[ $AWS == '' ]]; then
    apt-get install curl unzip -y
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip

    sudo ./aws/install

fi

FIREWALL="$(sudo ufw status)"
if [[ $FIREWALL == 'Status: active' ]]; then 
    sudo ufw disable
    sudo ufw status
fi

DOCKER=$(which docker)
if [[ $DOCKER == '' ]]; then 
    echo 'Install docker ...'
    sudo apt-get dist-upgrade
    uname

    sudo apt-get remove docker docker-engine docker.io containerd runc -y
    sudo apt-get update

    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

    # Docker Engine 
    sudo apt-get update
    sudo apt install -y docker-ce
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    apt-cache madison docker-ce
    # very important to make sure docker work properly
    sudo chmod 666 /var/run/docker.sock
    sudo systemctl enable docker
    # sudo systemctl status docker
fi

DOCKER=$(which docker-compose)
if [[ $DOCKER == '' ]]; then 
    echo 'Install docker ...'

    sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    #should be version 1.23.1
    docker-compose version
fi


KUBECTL=`which kubectl`
if [[ -z ${KUBECTL} ]]; then
    echo "Installing kubectl"
    sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kubectl
    sudo chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
fi

ALIAS=$(cat ~/.bashrc | grep "kubectl")
if [[ $ALIAS == '' ]]; then
    echo "Add kubectl alias"
    echo 'alias k="kubectl"' >> ~/.bashrc
    source ~/.bashrc
fi

MINIKUBE="$(minikube version  | head -n 1 | awk '{print $3}')"
if [[ $MINIKUBE != 'v1.3.1' ]]; then
    echo 'Intall Minikube'
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.3.1/minikube-linux-amd64
    chmod +x minikube
    sudo mkdir -p /usr/local/bin/
    sudo install minikube /usr/local/bin/
    rm -rf ./minikube
fi

SKAFFOLD=`which skaffold`
if [[ -z ${SKAFFOLD} ]]; then
    echo "Installing skaffold"
    curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/v0.38.0/skaffold-linux-amd64
    chmod +x skaffold
    sudo mv skaffold /usr/local/bin
fi

HELM=`which helm`
if [[ -z ${HELM} ]]; then
    echo "Installing helm version v3 "
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
fi

LIBREOFFICE="$(apt-cache policy libreoffice)"
if [[ $LIBREOFFICE == '' ]]; then
    echo "Install libreoffice"
    sudo add-apt-repository ppa:libreoffice/ppa
    sudo apt-get update
    sudo apt-get install libreoffice
fi

REMMINA="$(apt-cache policy remmina)"
if [[ $REMMINA == '' ]]; then
    echo "Install remmina"
    sudo apt install remmina -y
fi

GCLOUD=`which gcloud`
if [[ -z ${GCLOUD} ]]; then
    echo "Installing gcloud"
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-376.0.0-linux-x86_64.tar.gz
    tar -xf google-cloud-sdk-376.0.0-linux-x86_64.tar.gz
    ./google-cloud-sdk/install.sh

    gcloud components install gke-gcloud-auth-plugin
fi

OPSWATCLIENT=`which opswat-client`
if [[ -z ${OPSWATCLIENT} ]]; then
    echo 'Install opswat client'
    sudo wget -qO- https://s3-us-west-2.amazonaws.com/opswat-gears-cloud-clients-beta/linux_installer/latest/opswatclient_deb.tar | sudo tar xvf -
    sudo chmod +x opswatclient_deb/setup.sh
    cd opswatclient_deb
    sudo ./setup.sh -s=2358 -l=1fe5287dfe1ca8204f330325d1b20bbe
    cd ..
    opswat-client -r
fi


```
# Install Microsoft Defender for Endpoint

```
wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list -O /etc/apt/sources.list.d/microsoft-prod.list
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y mdatp


```


# Install cursor

Install dependencies

sudo apt install libfuse2

Download cursor from this page https://cursor.com/

nano ~/.local/share/applications/cursor.desktop

```
Name=Cursor
Exec=/home/thuanho/Applications/Cursor-1.5.11-x86_64.AppImage --no-sandbox
Icon=utilities-terminal
Type=Application
Categories=Utility;
StartupNotify=true
Terminal=false


```


# Install Lens Open Source Project
```sh
cd lens
bash install_lens.sh
```

# Install google chrome, vscode, Teams, NoSQL for MongoDB

https://www.google.com/intl/vi/chrome/

https://www.microsoft.com/en-us/microsoft-teams/download-app#desktopAppDownloadregion

https://code.visualstudio.com/download

https://nosqlbooster.com/downloads
```sh
sudo apt install ./code_1.75.0-1675266613_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
sudo apt install ./teams_1.5.00.23861_amd64.deb
sudo chmod +x ./nosqlbooster4mongo-8.0.2.AppImage

```

# Install Lens Open Source Project
```sh
LINT="$(code --list-extensions | grep 'dbaeumer.vscode-eslint')"
if [[ $LINT != 'dbaeumer.vscode-eslint' ]]; then 
    echo "Install vscode-extension"
    code --install-extension michelemelluso.code-beautifier
    code --install-extension mrmlnc.vscode-scss
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension donjayamanne.githistory
    code --install-extension eamodio.gitlens
    code --install-extension ms-python.python
    code --install-extension ms-azuretools.vscode-docker
    
    code --list-extensions
fi

```

## Setting VsCode

- Install pep8
```bash
pip install pep8
pip install autopep8
pip install --upgrade autopep8
```
- Goto File-> Preferences -> Settings
- Search for "python.formatting.autopep8Args"
- Add two items below:
```
    --max-line-length
    12000
```

## Bin

```bash


function installTools() {
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -o awscliv2.zip
    sudo ./aws/install

    rm -rf aws/
    rm -rf awscliv2.zip
    # Install eksctl
    # Bug in latest https://github.com/weaveworks/eksctl/issues/2270
    # curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/0.20.0/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

    sudo mv /tmp/eksctl /usr/local/bin

    # Install kubectl
    #curl --silent -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
    curl --silent -LO https://storage.googleapis.com/kubernetes-release/release/v1.22.0/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/

    sudo pip install --user --upgrade awscli

    /usr/local/bin/eksctl utils write-kubeconfig --cluster %env.CLUSTER_NAME% --region %env.REGION%

    #sed -i .bak -e 's/v1alpha1/v1beta1/' ~/.kube/config
    cat ~/.kube/config

    export PATH=$PATH:/usr/local/bin

    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    DESIRED_VERSION=v3.8.2 bash get_helm.sh

    rm -rf ./get_helm.sh
}

```
