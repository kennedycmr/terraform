#!/bin/bash 

########################################################
# This script is used to setup a Docker container with 
# the needed Python environment + Google packages so 
# that calls can be made by Python scripts. 
########################################################
printf "\n\n\n"
export ENV=dev

if [ -z "${ENV+1}" ]; then
    printf "\nNo \$ENV export found\n"
    printf "Enter the environment (e.g. dev or prd): "
    read ENV
    export ENV=$ENV
fi


if [ "$ENV" == "dev" ]; then 
    printf "Setting DEV environment...\n"
    export GCP_PROJECT_ID=xxxxxxx
    export GCP_DEFAULT_REGION=us-east4
    export GCP_KEYS=/workdir/test/run.keys.json
    export GOOGLE_APPLICATION_CREDENTIALS=${GCP_KEYS}
    export PY_REQUIREMENTS_FILE=/workdir/test/requirements.txt


elif [ "$ENV" == "prd" ]; then
    printf "Setting PRD environment...\n"
    exit 1


else
    printf "Please sent variable ENV to dev or prd\n"
    kill -INT $$
fi


# Static across environments
export WORKDIR=/workdir


### Setup local development environment
printf '\n\n'

printf "Setting gcloud project to: ${GCP_PROJECT_ID}...\n"
gcloud config set project ${GCP_PROJECT_ID}


printf "\nConfiguring gcloud to the deployment key..."
gcloud auth activate-service-account --key-file ${GCP_KEY_FILE}


printf 'Updating Debian packages...\n\n\n'
apt update
apt-get install -y unzip gettext-base python3 python3-dev python3-venv wget vim

printf 'Setting useful aliases...\n'
alias ll='ls -al'


printf "Setting up python virtual environment and installing dependancies...\n\n"

cd /opt
if [ -f ./get-pip.py ]; then
  rm -f ./get-pip.py
fi

wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py

export PY_VIRT=/tmp/py-virt
if [ -d ${PY_VIRT} ]; then 
  rm -rf ${PY_VIRT}
fi 

mkdir -p ${PY_VIRT}
cd ${PY_VIRT}

python3 -m venv env
source env/bin/activate

# Now install packages 

export PY_MODULES="wheel 
                   oauth2client 
                   requests"
pip3 install --upgrade pip
pip install ${PY_MODULES} --upgrade

if [ -f $PY_REQUIREMENTS_FILE ]; then
  pip3 install --upgrade -r ${WORKDIR}/cloudfunctionSource/requirements.txt
fi

printf "Host files are mounted to: ${WORKDIR}\n\n"
cd $WORKDIR
