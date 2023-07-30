# Kubernetes Deployment with Prometheus and Grafana using Helm

This README.md file provides step-by-step instructions for deploying Prometheus and Grafana on Kubernetes using Helm. Prometheus is a monitoring and alerting toolkit, while Grafana is a data visualization and analytics platform. Helm is a package manager for Kubernetes that simplifies the deployment and management of applications.

## Prerequisites

Before you begin, make sure you have the following prerequisites set up on your Kubernetes cluster:

1. **Kubernetes Cluster**: Ensure you have a running Kubernetes cluster, and you have the `kubectl` command-line tool configured to interact with the cluster.

2. **Helm**: Install Helm on your local machine and initialize it on your Kubernetes cluster. Follow the official Helm documentation for installation instructions: [Helm Install](https://helm.sh/docs/intro/install/).

## Deployment Steps

Follow the steps below to deploy Prometheus and Grafana on your Kubernetes cluster using Helm:

1. **Add Helm Repositories**: Helm uses repositories to fetch charts (packages) that define the applications to be deployed. Add the required repositories to Helm:

   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo add grafana https://grafana.github.io/helm-charts
   helm repo update
   ```

2. **Create Namespace**: It's a good practice to deploy Prometheus and Grafana in their dedicated namespaces. Create the namespaces (if they don't exist) using:

   ```bash
   kubectl create namespace prometheus
   kubectl create namespace grafana
   ```

3. **Install Prometheus**: Deploy Prometheus in the `prometheus` namespace using the Prometheus Helm chart:

   ```bash
   helm install prometheus prometheus-community/prometheus --namespace prometheus
   ```

4. **Install Grafana**: Deploy Grafana in the `grafana` namespace using the Grafana Helm chart:

   ```bash
   helm install grafana grafana/grafana --namespace grafana
   ```

5. **Retrieve Grafana Admin Password**: Retrieve the Grafana admin password generated during the installation:

   ```bash
   kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
   ```

   Save this password as you will use it to log in to the Grafana dashboard.

6. **Access Grafana Dashboard**: To access the Grafana dashboard, create a Kubernetes service to expose Grafana:

   ```bash
   kubectl expose deployment grafana --type=NodePort --name=grafana-service --namespace=grafana
   ```

   Retrieve the NodePort assigned to the Grafana service:

   ```bash
   kubectl get svc grafana-service --namespace=grafana
   ```

   Note down the port number and the external IP address of one of your cluster nodes. You can now access Grafana using `http://EXTERNAL_IP:NODE_PORT` in your web browser.

7. **Configure Prometheus as Datasource in Grafana**: In the Grafana dashboard, navigate to Configuration > Data Sources > Add Data Source. Choose Prometheus as the data source type, and set the URL to `http://prometheus-server.prometheus.svc.cluster.local`.

8. **Import Grafana Dashboards (Optional)**: Grafana has a variety of pre-built dashboards available for monitoring various applications and services. You can import dashboards from the Grafana community or create your own.

## Cleanup

To uninstall Prometheus and Grafana along with their configurations, use the following Helm commands:

```bash
helm uninstall prometheus --namespace prometheus
helm uninstall grafana --namespace grafana
```

Additionally, you can delete the dedicated namespaces if you no longer need them:

```bash
kubectl delete namespace prometheus
kubectl delete namespace grafana
```

## Additional Resources

- [Prometheus Helm Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus)
- [Grafana Helm Chart](https://github.com/grafana/helm-charts/tree/main/charts/grafana)

## Conclusion

You have successfully deployed Prometheus and Grafana on your Kubernetes cluster using Helm. You can now monitor and visualize the metrics and logs from your Kubernetes applications with ease. Enjoy exploring the power of Prometheus and Grafana for observability! 📈