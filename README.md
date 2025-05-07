# Decentralized Cloud Infrastructure

This project sets up a decentralized cloud infrastructure using Terraform, combining multiple decentralized technologies including Akash Network, IPFS, and Filecoin with monitoring capabilities. I have elevated the docker and virtualation to mock the implementation. 



## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or later)
- [Docker](https://docs.docker.com/get-docker/) (latest stable version)
- [Docker Compose](https://docs.docker.com/compose/install/) (latest stable version)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (for Akash network interaction)

## Project Structure

```
decentralized-cloud/
├── terraform/           # Terraform configuration files
│   ├── main.tf         # Main Terraform configuration
│   └── modules/        # Terraform modules
│       ├── akash/      # Akash network node
│       ├── ipfs/       # IPFS node
│       ├── filecoin/   # Filecoin node (optional)
│       └── monitoring/ # Monitoring stack (Prometheus + Grafana)
├── diagrams/           # Architecture and system diagrams
└── docs/              # Additional documentation
```

## Components

1. **Akash Network Node**: A decentralized cloud computing marketplace
2. **IPFS Node**: InterPlanetary File System for decentralized storage
3. **Filecoin Node** (Optional): Additional decentralized storage backup
4. **Monitoring Stack**: Prometheus and Grafana for system monitoring

## Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd decentralized-cloud
   ```

2. **Initialize Terraform**
   ```bash
   cd terraform
   terraform init
   ```

3. **Review and Modify Configuration**
   - Review the configuration in `terraform/main.tf`
   - Modify any variables or settings as needed
   - The default configuration uses Docker provider for local development

4. **Apply the Infrastructure**
   ```bash
   terraform apply
   ```
   This will create:
   - Akash network node
   - IPFS node
   - Filecoin node (if enabled)
   - Monitoring stack (Prometheus + Grafana)

5. **Access the Services**
   After successful deployment, you can access:
   - Prometheus: URL will be shown in the output
   - Grafana: URL will be shown in the output
   - IPFS: Access through the container ID shown in the output
   - Akash: Access through the container ID shown in the output

## Monitoring

The monitoring stack includes:
- Prometheus for metrics collection
- Grafana for visualization
- Default dashboards for monitoring:
  - System metrics
  - Container metrics
  - Network metrics

## Cleanup

To destroy all created resources:
```bash
terraform destroy
```

## Additional Documentation

For more detailed information about each component, refer to the documentation in the `docs/` directory.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

[Add your license information here]

## Support

[Add support information here] 