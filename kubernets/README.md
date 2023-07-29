# Kubernetes Deployment for Nginx and MySQL with Monitoring using Prometheus and Grafana

This repository contains the necessary files and configurations to deploy Nginx and MySQL on a Kubernetes cluster, along with setting up monitoring using Prometheus and Grafana.

## Prerequisites

Before proceeding, make sure you have the following installed:

1. Kubernetes cluster: Ensure you have a functional Kubernetes cluster up and running.
2. `kubectl`: The Kubernetes command-line tool (`kubectl`) must be installed and configured to connect to your Kubernetes cluster.
3. Helm: We'll use Helm to install Prometheus and Grafana.

## Deployment

### Step 1: Deploy Nginx and MySQL

We will use Kubernetes Deployments to deploy Nginx and MySQL. The deployment files are already provided in the repository.

1. Deploy Nginx:

```bash
kubectl apply -f nginx-deployment.yaml
```

2. Deploy MySQL:

```bash
kubectl apply -f mysql-deployment.yaml
```

Ensure that the Nginx and MySQL deployments are successfully created and running:

```bash
kubectl get deployments
kubectl get pods
```

### Step 2: Expose Nginx to External Traffic

We will expose Nginx externally using a Kubernetes Service of type NodePort.

```bash
kubectl apply -f nginx-service.yaml
```

### Step 3: Set Up Monitoring with Prometheus and Grafana

We will use Helm to install Prometheus and Grafana on our Kubernetes cluster.

1. Install Prometheus:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus
```

2. Install Grafana:

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana
```

### Step 4: Access Prometheus and Grafana Dashboards

By default, the Prometheus and Grafana services are exposed as ClusterIP. To access them externally, we will set up port forwarding.

1. For Prometheus:

```bash
kubectl port-forward svc/prometheus-server 9090:9090
```

Now, you can access Prometheus at `http://localhost:9090` in your web browser.

2. For Grafana:

```bash
kubectl port-forward svc/grafana 3000:80
```

Now, you can access Grafana at `http://localhost:3000` in your web browser. Use the default username `admin` and the password provided by Grafana during installation to log in.

### Step 5: Configure Prometheus Data Source in Grafana

1. Log in to Grafana using the credentials provided earlier.

2. Navigate to `Configuration` > `Data Sources` > `Add data source`.

3. Select `Prometheus` as the data source type.

4. In the HTTP settings section, set `http://prometheus-server` as the URL.

5. Click `Save & Test` to test the connection. You should see a "Data source is working" message.

### Step 6: Import Prometheus Dashboard in Grafana

1. In Grafana, go to `Create` > `Import`.

2. Enter the following Dashboard ID to import the pre-configured Prometheus dashboard for Kubernetes:

   Dashboard ID: `10856`

3. Click `Load`.

Now, you have a Grafana dashboard set up with metrics collected from Prometheus.

## Cleanup

To clean up the resources, run the following commands:

```bash
kubectl delete deployment nginx-deployment
kubectl delete deployment mysql-deployment
kubectl delete service nginx-service
helm uninstall prometheus
helm uninstall grafana
```

## Conclusion

Congratulations! You have successfully deployed Nginx and MySQL on Kubernetes and set up monitoring using Prometheus and Grafana. Now you can monitor the performance of your applications and infrastructure with the Grafana dashboard. For more advanced configuration and customization, refer to the official documentation of Prometheus, Grafana, and Kubernetes.