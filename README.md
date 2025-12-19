# Spring Scaffolding - Group B

## Overview

**Spring Scaffolding Group B** is a dynamic RESTful API built with **Spring Boot 3.4.5** and **Java 21**. It provides a generic interface to interact with relational databases (MySQL by default) without requiring specific entity classes for every table. The application utilizes `JdbcTemplate` and `DatabaseMetaData` to perform dynamic CRUD operations and schema inspection.

This project comes fully containerized with **Docker** and **Docker Compose**, including a pre-populated MySQL database initialized with an Academic Management System schema (`sisacad`).

## Key Features

* **Dynamic Schema Inspection**: Retrieve a list of all tables and column metadata (names and types) dynamically at runtime.
* **Generic CRUD Operations**: Perform Create, Read, Update, and Delete operations on any table within the database schema via REST endpoints.
* **Dockerized Environment**: Multi-stage Docker build for the application and a dedicated MySQL 8.0 container with initialization scripts.
* **Pre-loaded Schema**: Includes `sisacad.sql`, a robust database schema for academic management (Universities, Faculties, Careers, Students, Professors, etc.).

## Tech Stack

* **Language**: Java 21
* **Framework**: Spring Boot 3.4.5
* **Build Tool**: Maven 3.9.x (Wrapper included)
* **Database**: MySQL 8.0 (Compatible with PostgreSQL via dependencies)
* **Data Access**: Spring JDBC (JdbcTemplate)
* **Containerization**: Docker & Docker Compose

## Project Architecture

```text
springScaffolding/
├── .dockerignore
├── .env                  # Environment variables for local dev (if applicable)
├── Dockerfile            # Multi-stage build for Spring Boot
├── docker-compose.yml    # Orchestration of App + MySQL
├── pom.xml               # Maven dependencies
├── sisacad.sql/          # Database initialization script
│   └── sisacad.sql
└── src/
    └── main/
        ├── java/com/ulasalle/iw/springscaffolding_grupob/
        │   ├── controller/   # DatabaseController (REST API)
        │   └── service/      # DatabaseService (JDBC Logic)
        └── resources/
            └── application.properties
```
## Prerequisites
Docker and Docker Compose installed on your machine.

(Optional) Java 21 JDK and Maven if running outside of Docker.

Installation & Running
The easiest way to run the application is using Docker Compose, which sets up both the API and the Database automatically.

Clone the repository:
```
Bash

git clone <repository-url>
cd springScaffolding-3c57b2a72fc8de03a636249191831f5535c907ea
```
Build and Run with Docker Compose:
```
Bash

docker-compose up --build
```
The MySQL container (mysql_custom) will start and execute the sisacad.sql script to initialize the database.

The Spring Boot application (spring_scaffolding_grupob) will build and start on port 8080.
```
Verify Deployment: Access the application at: http://localhost:8080/api/tablas
```
## API Documentation
The DatabaseController exposes the following endpoints under the /api prefix.

1. Schema Introspection
List All Tables
```
GET /api/tablas

Response: ["academic_degrees", "students", "universities", ...]

List Table Columns

GET /api/tablas/{tableName}/columnas

Example: /api/tablas/students/columnas

Response:

JSON

[
  { "nombre": "id", "tipo": "INT" },
  { "nombre": "first_name", "tipo": "VARCHAR" }
]
```
2. Data Operations (CRUD)
Get Data (Select All)
```
GET /api/tablas/{tableName}

Example: /api/tablas/universities

Response: Array of objects representing rows.

Insert Data

POST /api/tablas/{tableName}

Body (JSON): Key-value pairs matching column names.

Example:

JSON

{
  "name": "Universidad Nacional de Ingeniería",
  "acronym": "UNI",
  "created_id": 1
}
```
Update Data
```
PUT /api/tablas/{tableName}/{idColumnName}/{idValue}

Description: Updates a record where {idColumnName} = {idValue}.

Example: /api/tablas/universities/id/8

Body (JSON): Fields to update.

JSON

{
  "acronym": "UNI-UPDATED"
}
```
Delete Data
```
DELETE /api/tablas/{tableName}/{idColumnName}/{idValue}

Example: /api/tablas/universities/id/8
```
## Configuration
The application configuration is managed via src/main/resources/application.properties and environment variables in docker-compose.yml.

Default Docker Environment:
```
DB URL: jdbc:mysql://mysql_custom:3306/sisacad

DB User: root

DB Password: 123456
```
To change database credentials, modify the .env file or update the environment section in docker-compose.yml.

Troubleshooting
Database Connection Refused: Ensure the mysql_custom container is fully healthy before the Spring app attempts to connect. The depends_on clause in Docker Compose handles startup order, but MySQL initialization (running the heavy SQL script) might take a few seconds on the first run.
```
Port Conflicts: Ensure ports 8080 (App) and 3306 (MySQL) are not occupied on your host machine.
```
