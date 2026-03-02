# User Service

Connects to shared RDS PostgreSQL. User tables: `users`, `user_email_confirmations`, `user_password_resets`.

## Database schema

Flyway migrations create the following tables in the shared database.

### `users`

| Column         | Type         | Constraints                    |
|----------------|--------------|--------------------------------|
| `user_id`      | UUID         | PK, default `gen_random_uuid()` |
| `email`        | VARCHAR(255) | NOT NULL, UNIQUE               |
| `password_hash`| VARCHAR(255) | NOT NULL                       |
| `role`         | VARCHAR(50)  | NOT NULL, CHECK (CUSTOMER/ADMIN) |
| `created_at`   | TIMESTAMP    | NOT NULL, default now          |
| `updated_at`   | TIMESTAMP    | NOT NULL, default now          |

- Index: `idx_users_email` on `email`.

### `user_email_confirmations`

| Column          | Type         | Constraints                          |
|-----------------|--------------|--------------------------------------|
| `confirmation_id` | UUID      | PK, default `gen_random_uuid()`      |
| `user_id`       | UUID         | NOT NULL, FK → `users(user_id)` ON DELETE CASCADE |
| `token`         | VARCHAR(512) | NOT NULL                             |
| `expires_at`    | TIMESTAMP    | NOT NULL                             |
| `created_at`    | TIMESTAMP    | NOT NULL, default now                |
| `confirmed_at`  | TIMESTAMP    | nullable                             |

- Index: `idx_user_email_confirmations_user_id` on `user_id`.

### `user_password_resets`

| Column       | Type         | Constraints                          |
|--------------|--------------|--------------------------------------|
| `reset_id`   | UUID         | PK, default `gen_random_uuid()`      |
| `user_id`    | UUID         | NOT NULL, FK → `users(user_id)` ON DELETE CASCADE |
| `token`      | VARCHAR(512) | NOT NULL                             |
| `expires_at` | TIMESTAMP    | NOT NULL                             |
| `created_at` | TIMESTAMP    | NOT NULL, default now                |

- Index: `idx_user_password_resets_user_id` on `user_id`.

## Run locally

Set the RDS password via environment variable (never commit the password):

```bash
export SPRING_DATASOURCE_PASSWORD=your_rds_master_password
mvn spring-boot:run
```

Or from repo root:

```bash
export SPRING_DATASOURCE_PASSWORD=your_rds_master_password
mvn -pl user-service spring-boot:run
```

On startup, Flyway runs migrations and creates the user tables if they do not exist. The service listens on port 8081.
