# Vacations Backend

A Spring Boot application for managing vacation requests with JWT authentication, PostgreSQL database, and Flyway migrations.

## Technologies

- **Java 21**
- **Spring Boot 3.2.0**
- **PostgreSQL 16**
- **Flyway** for database migrations
- **JWT** (JSON Web Tokens) for authentication
- **Docker** for containerization
- **Maven** for build management

## Database Schema

The application uses the following main tables:
- `users` - User information
- `profile` - User roles (ADMIN, RH, TL, USER)
- `user_profile` - User-profile relationships
- `user_manager` - Hierarchical relationships
- `vacation_request` - Vacation requests
- `vacation_approval` - Approval workflow
- `vacation_balance` - Vacation day balances
- `type` - Request types
- `period` - Period types (full day, morning, afternoon)

## Prerequisites

- Java 21
- Maven 3.9+
- Docker and Docker Compose (for containerized deployment)

## Running with Docker

### Start PostgreSQL only:

```bash
docker-compose up -d postgres
```

### Start the entire application (PostgreSQL + Spring Boot):

```bash
docker-compose up -d
```

### Stop the application:

```bash
docker-compose down
```

### Stop and remove volumes:

```bash
docker-compose down -v
```

## Running Locally

### 1. Start PostgreSQL:

```bash
docker-compose up -d postgres
```

### 2. Build and run the application:

```bash
mvn clean install
mvn spring-boot:run
```

The application will be available at `http://localhost:8080`

## API Endpoints

### Authentication

#### Register
```bash
POST /api/auth/register
Content-Type: application/json

{
  "nome": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "dataAdmissao": "2024-01-01",
  "profileNome": "USER"
}
```

#### Login
```bash
POST /api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

Response:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "email": "john@example.com",
  "nome": "John Doe"
}
```

### Vacation Requests (Authenticated)

All vacation endpoints require JWT token in the Authorization header:
```
Authorization: Bearer <your-jwt-token>
```

#### Get all vacation requests
```bash
GET /api/vacations
```

#### Get vacation request by ID
```bash
GET /api/vacations/{id}
```

#### Get vacation requests by user
```bash
GET /api/vacations/user/{userId}
```

#### Get vacation requests by status (TL, RH, ADMIN only)
```bash
GET /api/vacations/status/{status}
```

## Database Configuration

### Local Development
Edit `src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/vacations_db
spring.datasource.username=postgres
spring.datasource.password=postgres
```

### Docker
The application automatically uses `application-docker.properties` when running in Docker.

## Flyway Migrations

Migrations are located in `src/main/resources/db/migration/`

- `V1__initial_schema.sql` - Creates all tables and initial data

Flyway runs automatically on application startup.

## Security Configuration

The application uses JWT tokens with the following configuration:
- Token expiration: 24 hours (86400000 ms)
- Password encoding: BCrypt
- Role-based access control (ADMIN, RH, TL, USER)

### Public endpoints:
- `/api/auth/**` - Registration and login

### Protected endpoints:
- All other endpoints require authentication
- Admin endpoints require ADMIN role

## Building the Application

```bash
# Clean and build
mvn clean package

# Skip tests
mvn clean package -DskipTests

# Run tests
mvn test
```

## Project Structure

```
src/
├── main/
│   ├── java/com/haka/vacations/
│   │   ├── config/          # Security configuration
│   │   ├── controller/      # REST controllers
│   │   ├── dto/            # Data Transfer Objects
│   │   ├── entity/         # JPA entities
│   │   ├── repository/     # Spring Data repositories
│   │   ├── security/       # JWT utilities and filters
│   │   └── service/        # Business logic
│   └── resources/
│       ├── db/migration/   # Flyway migrations
│       └── application*.properties
```

## Troubleshooting

### Maven Certificate Error
If you encounter certificate errors when downloading dependencies, you may need to:
1. Update your Maven settings
2. Clear Maven cache: `rm -rf ~/.m2/repository`
3. Run with force update: `mvn clean install -U`

### Database Connection Issues
1. Ensure PostgreSQL is running: `docker-compose ps`
2. Check logs: `docker-compose logs postgres`
3. Verify connection settings in application.properties

## License

This project is licensed under the MIT License.
