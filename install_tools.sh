
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
    sudo add-apt-repository ppa:atareao/telegram -y
    sudo apt update
    sudo apt install -y telegram
fi

BAMBOO="$(apt-cache policy ibus-bamboo)"
if [[ $BAMBOO == '' ]]; then
    echo "Install ibus-bamboo"
    sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo -y
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
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y

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
    sudo add-apt-repository ppa:libreoffice/ppa -y
    sudo apt-get update
    sudo apt-get install libreoffice
fi

REMMINA="$(apt-cache policy remmina)"
if [[ $REMMINA == '' ]]; then
    echo "Install remmina"
    sudo apt install remmina -y
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