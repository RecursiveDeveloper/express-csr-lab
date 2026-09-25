# Express CSR Lab

Sample Express.js project following the **Controller-Service-Repository** pattern with MongoDB.

## Folder Structure

```
express-csr-lab/
├── docker-compose.yml
├── .env                        # Environment variables (MongoDB credentials) — not committed, must be created manually
├── run.sh                      # Build and start containers
├── stop.sh                     # Stop and remove containers + images
├── seed.sh                     # Seed 20 random users via API
├── monitoring/
│   ├── prometheus.yml          # Prometheus scrape config
│   └── provisioning/
│       └── datasources/
│           └── datasource.yml  # Grafana datasource provisioning
└── app/
    ├── .dockerignore
    ├── Dockerfile
    ├── package.json
    └── src/
        ├── app.js              # Entry point
        ├── config/
        │   └── db.js           # MongoDB connection
        ├── models/
        │   └── User.js         # Mongoose schema
        ├── repositories/
        │   └── UserRepository.js # Data access layer
        ├── services/
        │   └── UserService.js  # Business logic layer
        ├── controllers/
        │   └── UserController.js # Request/response handling
        └── routes/
            └── userRoutes.js   # Route definitions
```

## Architecture

The application follows a layered architecture:

- **Routes** -> Define HTTP endpoints and delegate to controllers
- **Controllers** -> Handle HTTP requests/responses and call services
- **Services** -> Contain business logic and call repositories
- **Repositories** -> Handle database operations (data access)
- **Models** -> Define Mongoose schemas and document structure

## Configuration

MongoDB credentials are read from environment variables. They live in `.env`, which Docker Compose loads automatically and injects into both containers.

| Variable         | Description                          | Example          |
|------------------|--------------------------------------|------------------|
| `MONGO_USERNAME` | MongoDB root username                | `root`           |
| `MONGO_PASSWORD` | MongoDB root password                | `toor`           |
| `MONGO_PORT`     | Port exposed by the mongo container  | `27017`          |
| `MONGO_DB`       | Database name used by the app        | `express_csr_lab` |

`MONGO_HOST` is set directly in `docker-compose.yml` (the `mongo` service hostname) and does not belong in `.env`.

All variables are **required**: on startup, `src/config/db.js` validates them and exits with an error if any is missing.

> `.env` is excluded from the Docker image via `.dockerignore`. Never commit it to version control.

## Prerequisites

- Node.js
- Docker & Docker Compose

## Environment Setup

Before running the project, you must create a `.env` file in the project root. This file is excluded from version control (see `.gitignore`) and is **required** for the application to start.

Create it by copying the example below:

```bash
# .env
MONGO_USERNAME=root
MONGO_PASSWORD=toor
MONGO_PORT=27017
MONGO_DB=express_csr_lab
```

> `MONGO_HOST` is set directly in `docker-compose.yml` and does not need to be in `.env`.

Without this file, Docker Compose will fail to inject the required credentials and the application will exit on startup.

## Installation

```bash
cd app
npm install
```

## Running the Application

### With Docker Compose (recommended)

```bash
./run.sh
```

This builds the image and starts all containers:

| Service             | Image                                        | Port     | Purpose                      |
|---------------------|----------------------------------------------|----------|------------------------------|
| `express`           | Built from `app/Dockerfile`                  | `3000`   | The application              |
| `mongo`             | `mongo:8.3.8`                                | -        | MongoDB database             |
| `mongodb-exporter`  | `percona/mongodb_exporter:0.43`              | -        | Exports MongoDB metrics      |
| `prometheus`        | `ubuntu/prometheus:3.11-26.04_stable`        | `9090`   | Metrics collection           |
| `grafana`           | `grafana/grafana:nightly`                    | `3000`   | Dashboards & visualization   |

To stop and clean up (containers, networks, and images):

```bash
./stop.sh
```

### Without Docker

Requires a local MongoDB instance. Export the environment variables before starting, pointing `MONGO_HOST` to your machine:

```bash
export MONGO_USERNAME=root
export MONGO_PASSWORD=toor
export MONGO_HOST=localhost
export MONGO_PORT=27017
export MONGO_DB=express_csr_lab

cd app
node src/app.js
```

The server starts on `http://localhost:3000`.

## Seed Data

To populate the database with 20 sample users:

```bash
./seed.sh
```

The script generates random users and posts them to the running API. The default target is `http://localhost:3000/api/users`. Override with:

```bash
API_URL=http://other-host:3000/api/users ./seed.sh
```

## Monitoring

- **Prometheus** is available at `http://localhost:9090` and scrapes both itself and the MongoDB exporter every 15 seconds. The scrape configuration lives in `monitoring/prometheus.yml`.
- **Grafana** is available at `http://localhost:3000` with Prometheus pre-provisioned as the default datasource. The provisioning file lives in `monitoring/provisioning/datasources/datasource.yml`.

## API Routes

| Method | Endpoint       | Description       |
|--------|----------------|-------------------|
| GET    | `/api/users`   | Get all users     |
| GET    | `/api/users/:id` | Get user by ID  |
| POST   | `/api/users`   | Create a new user |

### Examples

**Get all users:**

```bash
curl http://localhost:3000/api/users
```

**Get user by ID:**

```bash
curl http://localhost:3000/api/users/<id>
```

**Create a user:**

```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com", "age": 30}'
```
