PROJECT=`gcloud config get-value project`
kops create cluster simple.k8s.local --zones us-central1-a --state ${KOPS_STATE_STORE}/ --project=${PROJECT}

kops update cluster simple.k8s.local --yes
