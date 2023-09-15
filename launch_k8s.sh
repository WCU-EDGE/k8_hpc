#!/bin/bash

log_info() {
  printf "\n\e[0;35m $1\e[0m\n\n"
}

log_warn() {
  printf "\e[0;33m $1\e[0m\n"
}

convert() {
  kompose convert
}

network() {
  kubectl apply -f compute-network.yaml
}

#need to work on volumes
#volume() {
  #kubectl apply -f k8s/volumes.yaml
#}

ldap() {
  kubectl apply -f ldap/ldap.yaml
}

#we have no base-deployment.yaml
#base() {
  #kubectl apply -f base-deployment.yaml
#}


#we need to set up pv and pvc i believe
mongodb() {
  kubectl apply -f mongodb/mongodb-deployment.yaml                       
}

#pv and pvc for mysql as well
mysql() {
  kubectl apply -f mysql/mysql-deployment.yaml
}

#add etc slurm, etc munge pv/pvc
slurmdbd() {
  kubectl apply -f slurmdbd/slurmdbd-deployment.yaml
}

slurmctld() {
  kubectl apply -f slurmctld/slurmctld-deployment.yaml
}

compute() {
  kubectl apply -f cpn/cpn01.yaml
  kubectl apply -f cpn/cpn02.yaml
  kubectl apply -f cpn/cpn03.yaml
  kubectl apply -f cpn/cpn04.yaml
}

frontend() {
  kubectl apply -f frontend/frontend.yaml
}

coldfront() {
  kubectl apply -f coldfront/coldfront.yaml
}

ondemand() {
  kubectl apply -f ondemand/ondemand-deployment.yaml
}

xdmod() {
  kubectl apply -f xdmod/xdmod-deployment.yaml
}

ingress() {
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.4.0/deploy/static/provider/baremetal/deploy.yaml
  kubectl get svc -n ingress-nginx -o wide
  kubectl create ingress k8hpc --class=nginx --rule="$(hostname -f)/coldfront=coldfront:2443" --rule="$(hostname -f)/ondemand=ondemand:3443" --rule="$(hostname -f)/xdmod=xdmod:4443"
}

case "$1" in
  'all')
    network
    ldap
    mongodb
    mysql
    slurmdbd
    slurmctld
    compute
    frontend
    coldfront
    ondemand
    xdmod
    ingress
    ;;
  'convert')
    convert
    ;;
  'network')
    network
    ;;
  'volume')
    volume
    ;;
  'ldap')
    ldap
    ;;
  'mongodb')
    mongodb
    ;;
  'mysql')
    mysql
    ;;
  'slurmdbd')
    slurmdbd
    ;;
  'slurmctld')
    slurmctld
    ;;
  'compute')
    compute 
    ;;
  'frontend')
    frontend
    ;;
  'coldfront')
    coldfront 
    ;;
  'ondemand')
    ondemand 
    ;;
  'xdmod')
    xdmod 
    ;;
  'ingress')
    ingress
    ;;
  *)
    log_info "Usage: $0 {all | convert | ... | cleanup}"
    exit 1
    ;;
esac






