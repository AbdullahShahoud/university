# Audience API — Developer Documentation

> **Base URL:** `http://localhost:3000/api`  
> **Prefix:** All audience routes are mounted under `/audience`

---

## Table of Contents

1. [Overview](#overview)
2. [Authentication](#authentication)
3. [Common Conventions](#common-conventions)
4. [Auth Endpoints](#auth-endpoints)
5. [Audience Endpoints](#audience-endpoints)
   - [Startups](#startups)
   - [News](#news)
   - [Contact](#contact)
   - [Website](#website)
   - [Follow & Unfollow](#follow--unfollow)
   - [Favorite & Unfavorite](#favorite--unfavorite)
   - [My Lists](#my-lists)
6. [Data Models](#data-models)
7. [Error Reference](#error-reference)

---

## Overview

The Audience API is the public-facing layer of the platform. It lets anyone browse approved startups, read news, and send contact messages, while authenticated audience users can additionally follow startups, save favorites, and view their personal lists.

All routes under `/audience` (except `POST /audience/signup`) require a valid audience JWT — the router applies `protect` + `restrictTo('audience')` globally.

---

## Authentication

The API uses **JWT Bearer tokens**.

Include the token in every protected request:

```
Authorization: Bearer <jwt>
```

Tokens are issued at signup or login and can be refreshed with a refresh token.

---

## Common Conventions

### Pagination

All list endpoints accept these query parameters:

| Parameter | Type    | Default | Description          |
|-----------|---------|---------|----------------------|
| `page`    | integer | 1       | Page number          |
| `limit`   | integer | 20      | Items per page       |

Paginated responses include a `pagination` object:

```json
{
  "currentPage": 1,
  "totalPages": 5,
  "totalItems": 98,
  "itemsPerPage": 20
}
```

### Search

Endpoints that support search accept a `search` query parameter that performs a case-insensitive match across the documented searchable fields.

```
GET /audience/startups?search=fintech
```

### Response Envelope

All responses follow this envelope:

```json
{
  "status": "success",
  "message": "Human-readable message",
  "results": 10,
  "data": { ... }
}
```

---

## Auth Endpoints

These endpoints live under `/auth` (shared with other roles) plus the audience-specific signup.

---

### POST `/audience/signup`

Register a new audience account. On success, returns a JWT and refresh token.

**Auth required:** No

**Request body:**

```json
{
  "name": "Jane Doe",
  "email": "jane@example.com",
  "password": "password123",
  "passwordConfirm": "password123"
}
```

| Field             | Type   | Required | Notes                        |
|-------------------|--------|----------|------------------------------|
| `name`            | string | Yes      |                              |
| `email`           | string | Yes      | Must be unique               |
| `password`        | string | Yes      |                              |
| `passwordConfirm` | string | Yes      | Must match `password`        |

**Response `201`:**

```json
{
  "status": "success",
  "message": "Account created successfully",
  "data": {
    "token": "<jwt>",
    "refreshToken": "<refreshToken>"
  }
}
```

> **Postman note:** The test script automatically saves `jwt` and `refreshToken` as environment variables on a successful 201 response.

---

### POST `/auth/login`

Log in with email and password.

**Auth required:** No

**Request body:**

```json
{
  "email": "jane@example.com",
  "password": "password123"
}
```

**Response `200`:**

```json
{
  "data": {
    "token": "<jwt>",
    "refreshToken": "<refreshToken>"
  }
}
```

---

### POST `/auth/refreshToken`

Exchange a refresh token for a new JWT pair.

**Auth required:** No

**Request body:**

```json
{
  "refreshToken": "<refreshToken>"
}
```

---

### POST `/auth/forgotPassword`

Send a password reset code to the given email address.

**Request body:**

```json
{
  "email": "jane@example.com"
}
```

---

### POST `/auth/checkResetCode`

Verify the 6-digit reset code that was emailed to the user.

**Request body:**

```json
{
  "email": "jane@example.com",
  "resetCode": "963928"
}
```

---

### PATCH `/auth/resetPassword`

Set a new password using the reset token obtained after verifying the reset code.

**Request body:**

```json
{
  "password": "newpassword123",
  "passwordConfirm": "newpassword123",
  "resetToken": "<token>"
}
```

---

### PATCH `/auth/updateMyPassword`

Change the current user's password while logged in.

**Auth required:** Yes (Bearer)

**Request body:**

```json
{
  "passwordCurrent": "oldpassword123",
  "password": "newpassword123"
}
```

---

### GET `/auth/logout`

Invalidate the current session.

**Auth required:** Yes (Bearer)

---

### GET `/auth/sessions`

List all active sessions (devices) for the authenticated user.

**Auth required:** Yes (Bearer)

| Query param | Default | Max |
|-------------|---------|-----|
| `page`      | 1       | —   |
| `limit`     | 20      | 200 |

---

### DELETE `/auth/sessions/:sessionId`

Revoke a specific session by its ID (remote logout from one device).

**Auth required:** Yes (Bearer)

---

### POST `/auth/logout-all`

Invalidate all refresh tokens — logs the user out of every device.

**Auth required:** Yes (Bearer)

---

## Audience Endpoints

All endpoints below require an authenticated audience JWT unless otherwise noted.

---

## Startups

### GET `/audience/startups`

List all approved startups. Supports pagination and search.

**Auth required:** Yes (audience)

**Query parameters:**

| Parameter | Description                               |
|-----------|-------------------------------------------|
| `page`    | Page number (default: 1)                  |
| `limit`   | Items per page (default: 20)              |
| `search`  | Search by `name` or `description`         |

**Response `200`:**

```json
{
  "status": "success",
  "message": "Startups retrieved successfully",
  "results": 42,
  "data": {
    "startups": [
      {
        "id": 1,
        "name": "Acme Corp",
        "slug": "acme-corp",
        "description": "...",
        "activeBrand": {
          "id": 3,
          "assets": { ... },
          "is_active": true,
          "created_at": "2024-01-01T00:00:00.000Z"
        },
        "isFollowing": false,
        "isFavorited": true
      }
    ],
    "pagination": { "currentPage": 1, "totalPages": 3, "totalItems": 42, "itemsPerPage": 20 }
  }
}
```

> `isFollowing` and `isFavorited` are injected when the caller is an authenticated audience user.

---

### GET `/audience/startups/:slug`

Get a single approved startup by its URL slug.

**Auth required:** Yes (audience)

**Path parameter:**

| Parameter | Description      |
|-----------|------------------|
| `slug`    | Startup URL slug |

**Response `200`:**

```json
{
  "status": "success",
  "data": {
    "startup": {
      "id": 1,
      "name": "Acme Corp",
      "slug": "acme-corp",
      "description": "...",
      "activeBrand": { ... },
      "followerCount": 120,
      "favoriteCount": 45,
      "isFollowing": false,
      "isFavorited": false
    }
  }
}
```

**Errors:**

| Status | Condition             |
|--------|-----------------------|
| 404    | Startup not found or not approved |

---

## News

### GET `/audience/startups/:slug/news`

Paginated list of published news items for a startup. Supports search by title.

**Auth required:** Yes (audience)

**Query parameters:**

| Parameter | Description                     |
|-----------|---------------------------------|
| `page`    | Page number (default: 1)        |
| `limit`   | Items per page (default: 20)    |
| `search`  | Search by `title`               |

**Response `200`:**

```json
{
  "status": "success",
  "data": {
    "newsItems": [ { "id": 1, "title": "...", "published_at": "..." } ],
    "pagination": { ... }
  }
}
```

---

### GET `/audience/startups/:slug/news/:newsId`

Get a single published news item.

**Auth required:** Yes (audience)

**Path parameters:**

| Parameter | Description   |
|-----------|---------------|
| `slug`    | Startup slug  |
| `newsId`  | News item ID  |

**Response `200`:**

```json
{
  "status": "success",
  "data": {
    "newsItem": { "id": 1, "title": "...", "body": "...", "published_at": "..." }
  }
}
```

**Errors:**

| Status | Condition                        |
|--------|----------------------------------|
| 404    | Startup not found                |
| 404    | News item not found or unpublished |

---

## Contact

### POST `/audience/startups/:slug/contact`

Submit a contact/inquiry message to the startup owner.

**Auth required:** Yes (audience)

**Request body:**

```json
{
  "name": "Jane Doe",
  "email": "jane@example.com",
  "message": "Hi, I would like to know more about your services.",
  "phone": "+1234567890"
}
```

| Field     | Type   | Required | Notes                      |
|-----------|--------|----------|----------------------------|
| `name`    | string | Yes      |                            |
| `email`   | string | Yes      | Must be a valid email      |
| `message` | string | Yes      |                            |
| `phone`   | string | No       |                            |

**Response `201`:**

```json
{
  "status": "success",
  "message": "Message sent successfully",
  "data": {
    "submission": { "id": 7, "startup_id": 1, "name": "Jane Doe", ... }
  }
}
```

**Errors:**

| Status | Condition                        |
|--------|----------------------------------|
| 400    | Missing `name`, `email`, or `message` |
| 400    | Invalid email format             |
| 404    | Startup not found                |

---

## Website

### GET `/audience/websites/:slug`

Retrieve the published website for an approved startup, including its visible sections and latest 10 news items.

**Auth required:** Yes (audience)

**Path parameter:**

| Parameter | Description      |
|-----------|------------------|
| `slug`    | Startup URL slug |

**Response `200`:**

```json
{
  "status": "success",
  "data": {
    "startup": { "id": 1, "name": "Acme Corp", "slug": "acme-corp", "description": "..." },
    "brand": { ... },
    "website": {
      "sections": [
        { "id": 1, "type": "hero", "is_visible": true, "order_index": 0, "content": { ... } }
      ]
    },
    "news": [ { "id": 1, "title": "...", "published_at": "..." } ]
  }
}
```

**Errors:**

| Status | Condition                             |
|--------|---------------------------------------|
| 404    | Startup not found or not approved     |
| 404    | No published website for this startup |

---

## Follow & Unfollow

### POST `/audience/startups/:slug/follow`

Follow a startup.

**Auth required:** Yes (audience)

**Response `201`:** `"Successfully followed startup"`

**Errors:**

| Status | Condition                    |
|--------|------------------------------|
| 404    | Startup not found            |
| 404    | Already following this startup |

---

### DELETE `/audience/startups/:slug/follow`

Unfollow a startup.

**Auth required:** Yes (audience)

**Response `200`:** `"Successfully unfollowed startup"`

**Errors:**

| Status | Condition                        |
|--------|----------------------------------|
| 404    | Startup not found                |
| 404    | Not currently following          |

---

## Favorite & Unfavorite

### POST `/audience/startups/:slug/favorite`

Add a startup to favorites.

**Auth required:** Yes (audience)

**Response `201`:** `"Successfully added to favorites"`

**Errors:**

| Status | Condition              |
|--------|------------------------|
| 404    | Startup not found      |
| 404    | Already in favorites   |

---

### DELETE `/audience/startups/:slug/favorite`

Remove a startup from favorites.

**Auth required:** Yes (audience)

**Response `200`:** `"Successfully removed from favorites"`

**Errors:**

| Status | Condition                    |
|--------|------------------------------|
| 404    | Startup not found            |
| 404    | Startup not in favorites     |

---

## My Lists

### GET `/audience/me/following`

Paginated list of startups the authenticated audience user is following.

**Auth required:** Yes (audience)

**Query parameters:** `page`, `limit`

**Response `200`:**

```json
{
  "status": "success",
  "data": {
    "startups": [
      {
        "id": 1,
        "name": "Acme Corp",
        "activeBrand": { ... },
        "isFollowing": true,
        "isFavorited": false
      }
    ],
    "pagination": { ... }
  }
}
```

---

### GET `/audience/me/favorites`

Paginated list of startups the authenticated audience user has favorited.

**Auth required:** Yes (audience)

**Query parameters:** `page`, `limit`

**Response `200`:**

```json
{
  "status": "success",
  "data": {
    "startups": [
      {
        "id": 2,
        "name": "Beta Inc",
        "activeBrand": { ... },
        "isFollowing": false,
        "isFavorited": true
      }
    ],
    "pagination": { ... }
  }
}
```

---

## Data Models

### Startup (public)

| Field           | Type    | Description                                       |
|-----------------|---------|---------------------------------------------------|
| `id`            | integer |                                                   |
| `name`          | string  |                                                   |
| `slug`          | string  | URL-safe identifier                               |
| `description`   | string  |                                                   |
| `activeBrand`   | object  | The startup's currently active brand (or `null`)  |
| `followerCount` | integer | Only present on the single-startup endpoint       |
| `favoriteCount` | integer | Only present on the single-startup endpoint       |
| `isFollowing`   | boolean | Present only for authenticated audience users     |
| `isFavorited`   | boolean | Present only for authenticated audience users     |

> `user_id`, `approved_by`, and `approved_at` are stripped server-side and never exposed.

---

### Brand (active)

| Field        | Type    | Description                     |
|--------------|---------|---------------------------------|
| `id`         | integer |                                 |
| `assets`     | object  | Brand assets (logo, colors, etc.) |
| `is_active`  | boolean | Always `true` in public responses |
| `created_at` | string  | ISO 8601 timestamp              |

---

### AudienceFollow

Stored in `audience_follows`. Unique constraint on `(user_id, startup_id)`.

| Field        | Type    |
|--------------|---------|
| `id`         | integer |
| `user_id`    | integer |
| `startup_id` | integer |
| `created_at` | string  |
| `updated_at` | string  |

---

### AudienceFavorite

Stored in `audience_favorites`. Unique constraint on `(user_id, startup_id)`.

| Field        | Type    |
|--------------|---------|
| `id`         | integer |
| `user_id`    | integer |
| `startup_id` | integer |
| `created_at` | string  |
| `updated_at` | string  |

---

### NewsItem

| Field          | Type    | Description              |
|----------------|---------|--------------------------|
| `id`           | integer |                          |
| `startup_id`   | integer |                          |
| `title`        | string  |                          |
| `body`         | string  |                          |
| `is_published` | boolean | Only `true` items served |
| `published_at` | string  | ISO 8601 timestamp       |

---

### ContactSubmission

| Field        | Type    | Description   |
|--------------|---------|---------------|
| `id`         | integer |               |
| `startup_id` | integer |               |
| `name`       | string  |               |
| `email`      | string  |               |
| `message`    | string  |               |
| `phone`      | string  | Nullable      |

---

## Error Reference

All errors follow the same envelope:

```json
{
  "status": "error",
  "message": "Human-readable description"
}
```

| HTTP Status | Meaning                                      |
|-------------|----------------------------------------------|
| 400         | Bad request — validation failed              |
| 401         | Unauthorized — missing or invalid JWT        |
| 403         | Forbidden — authenticated but wrong role     |
| 404         | Resource not found                           |
| 409         | Conflict — duplicate follow/favorite attempt |
| 500         | Internal server error                        |
