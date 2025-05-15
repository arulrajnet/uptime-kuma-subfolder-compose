# Uptime Kuma with Subfolder Path

This repository provides a ready-to-use Docker Compose setup to run [Uptime Kuma](https://github.com/louislam/uptime-kuma) behind an Nginx reverse proxy with a subfolder path (`/kuma`).

## Purpose

Deploying Uptime Kuma under a subfolder (like `/kuma`) has been a common challenge as discussed in [Uptime Kuma issue #147](https://github.com/louislam/uptime-kuma/issues/147#issuecomment-2858297375). This project explain how it can be achieved using Docker Compose and Nginx.:

- Configuring Nginx as a reverse proxy to serve Uptime Kuma under a subfolder
- Providing a custom entrypoint script that modifies the necessary paths in the Uptime Kuma frontend
- Setting up proper environment variables to make everything work together

Adding support in the original Uptime Kuma will be a great improvement, but until then, this setup provides a workaround.

## Quick Start

### Prerequisites

- Docker and Docker Compose installed on your system
- Git (to clone this repository)

### Setup Instructions

1. Clone this repository:
   ```bash
   git clone https://github.com/arulrajnet/uptime-kuma-subfolder-compose.git
   cd uptime-kuma-subfolder-compose
   ```

2. Make the entrypoint script executable:
   ```bash
   chmod +x entrypoint.sh
   ```

3. Start the services using Docker Compose:
   ```bash
   docker compose up -d
   ```

4. Access Uptime Kuma at:
   ```
   http://localhost:8080/kuma
   ```

## How It Works

### Docker Compose Configuration

The `docker-compose.yml` file sets up:

1. An Nginx service acting as a reverse proxy
2. Uptime Kuma service configured to run under the `/kuma` path
3. Persistent volume for Uptime Kuma data

Key configurations in the Uptime Kuma service:
- The `SERVER_CONTEXTPATH: "/kuma"` environment variable tells Uptime Kuma to use the subfolder
- A custom entrypoint script modifies the frontend resources to work with the subfolder path

### Nginx Configuration

The `kuma-nginx.conf` file configures Nginx to:

1. Listen on port 8080
2. Proxy requests from `/kuma` to the Uptime Kuma service
3. Strip the `/kuma` prefix when forwarding requests
4. Add the `/kuma` prefix back to response headers (like Location)

```nginx
# Key part of the configuration
location /kuma {
    # Strip /kuma prefix
    rewrite ^/kuma/?(.*)$ /$1 break;

    # Proxy to upstream service
    proxy_pass http://kuma_service;
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

<p align="center">
  <a href="https://x.com/arulrajnet">
    <img src="https://github.com/arulrajnet.png?size=100" alt="Arulraj V" width="100" height="100" style="border-radius: 50%;" class="avatar-user">
  </a>
  <br>
  <strong>Arul</strong>
  <br>
  <a href="https://x.com/arulrajnet">
    <img src="https://img.shields.io/badge/Follow-%40arulrajnet-1DA1F2?style=for-the-badge&logo=x&logoColor=white" alt="Follow @arulrajnet on X">
  </a>
  <a href="https://github.com/arulrajnet">
    <img src="https://img.shields.io/badge/GitHub-arulrajnet-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub @arulrajnet">
  </a>
  <a href="https://linkedin.com/in/arulrajnet">
    <img src="https://custom-icon-badges.demolab.com/badge/LinkedIn-arulrajnet-0A66C2?style=for-the-badge&logo=linkedin-white&logoColor=white" alt="LinkedIn @arulrajnet">
  </a>
</p>
