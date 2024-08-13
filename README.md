# kubernets-external-secret-manager

- Create Application 
- Create a Dockerfile to build a Docker image for your PHP application:
- Create/Push Image to Dockerhub

	docker build -t your-dockerhub-username/php-app:tag .
	docker push your-dockerhub-username/php-app:tag
- Create a ConfigMap to store configuration data: configmap.yaml
- Create a deployment.yaml file to define the deployment of your PHP application:
- Create a service.yaml file to expose your PHP application using a Kubernetes service:


Deploy App over kubernets/minikube and test using below commands

- kubectl apply -f deployment.yaml
- kubectl apply -f service.yaml


Access the application using local ip or cluster external ip:port
- kubectl get services {service-name}
- minikube service php-minikube-service --url
- minikube service php-minikube-service
	Access you app using URL - display in output
	E.g. output
	 NAMESPACE |         NAME         | TARGET PORT |          URL           |
	|-----------|----------------------|-------------|------------------------|
	| default   | php-minikube-service |             | http://127.0.0.1:43483 |



IMPLEMENT EXTERNAL SECRET ->REPLACE THE EXISTING CONFIGMAP WITH AWS SECRET MANAGER

Prerequisites
AWS Account: You need an AWS account with Secrets Manager access.
AWS CLI: The AWS CLI should be installed and configured on your machine.
IAM Role: An IAM role with sufficient permissions to access the Secrets Manager and is associated with your Kubernetes cluster (if using EKS).

- Install External Secrets Operator: First, you need to install the External Secrets Operator in your Kubernetes cluster. You can do this with Helm:

	helm repo add external-secrets https://charts.external-secrets.io
	helm install external-secrets external-secrets/external-secrets


Store Secrets in AWS Secrets Manager:  First, create a secret in AWS Secrets Manager. You can store the key-value pair from your ConfigMap in this secret. For example, to store WELCOME_MESSAGE, run:

Create by code after AWS LOGIN:

aws secretsmanager create-secret --name php-app-secret --secret-string '{"WELCOME_MESSAGE":"Hello from Secrets Manager aws!"}'

Create manually -> Login to AWS Console -> Secrets -> Create new -> Setup vars



Create a SecretStore resource to configure how Kubernetes accesses AWS Secrets Manager. Save this as secretstore.yaml:
Create an ExternalSecret resource to sync the AWS Secrets Manager secret with Kubernetes. Save this as external-secret.yaml:


Remove configMap and use Aws secret ->  Update your deployment.yaml to use the new Kubernetes Secret created from the external secret:

       # - configMapRef:
          #name: php-config
        - secretRef:
            name: php-app-secrets


Apply  above manifests to retrieve the AWS secret manager:

kubectl apply -f aws-credentials.yaml
kubectl apply -f secretstore.yaml
kubectl apply -f external-secret.yaml

// Update the deployment to access the external secret 
kubectl apply -f deployment.yaml





Verify the Secret Creation


kubectl get secrets
kubectl describe secret php-app-secrets

If you want to decode the secret values to verify their correctness, you can use: [Bash Command]:
kubectl get secret aws-credentials -o jsonpath="{.data.aws_access_key_id}" | base64 --decode
kubectl get secret aws-credentials -o jsonpath="{.data.aws_secret_access_key}" | base64 --decode




1.Verify kubernets secret

 kubectl get secret php-app-secrets -o yaml
kubectl get secret php-app-secrets
kubectl get externalsecrets

2. Verify that the secret data is base64 encoded and correct. You can decode it to check [bash]:
 kubectl get secret php-app-secrets -o jsonpath="{.data.WELCOME_MESSAGE}" | base64 --decode

3.  Delete existing configmap to cross check: kubectl delete configmap php-app-secrets


Run the command to get the minikube IP: minikube service php-minikube-service

 minikube service php-minikube-service --url

 minikube service php-minikube-service
