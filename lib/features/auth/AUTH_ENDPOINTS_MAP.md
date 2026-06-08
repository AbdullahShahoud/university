# Auth Feature - Endpoints & Screens Mapping

## 📋 التوثيق الشامل لـ Auth Feature

---

## 1️⃣ تسجيل حساب جديد (Signup)

### Endpoint
```
POST /audience/signup
```

### Request Body
```json
{
  "name": "Jane Doe",
  "email": "jane@example.com",
  "password": "password123",
  "passwordConfirm": "password123"
}
```

### Response (201)
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

### Screen
📱 **SignupScreen** - `lib/features/auth/ui/screens/signup_screen.dart`
- Input fields: name, email, password, confirmPassword
- Validations: email format, password match
- Navigation: Link to login screen

---

## 2️⃣ تسجيل دخول (Login)

### Endpoint
```
POST /auth/login
```

### Request Body
```json
{
  "email": "jane@example.com",
  "password": "password123"
}
```

### Response (200)
```json
{
  "status": "success",
  "data": {
    "token": "<jwt>",
    "refreshToken": "<refreshToken>"
  }
}
```

### Screen
📱 **LoginScreen** - `lib/features/auth/ui/screens/login_screen.dart`
- Input fields: email, password
- Features: show/hide password toggle
- Links: Forgot password, Sign up

---

## 3️⃣ نسيت كلمة المرور (Forgot Password)

### Endpoint
```
POST /auth/forgotPassword
```

### Request Body
```json
{
  "email": "jane@example.com"
}
```

### Response (200)
```json
{
  "status": "success",
  "message": "Password reset code sent to your email"
}
```

### Screen
📱 **ForgotPasswordScreen** - `lib/features/auth/ui/screens/forgot_password_screen.dart`
- Step 1: Enter email
- Triggers: Email validation
- Transitions to: Verify Reset Code screen

---

## 4️⃣ التحقق من كود التحقق (Verify Reset Code)

### Endpoint
```
POST /auth/checkResetCode
```

### Request Body
```json
{
  "email": "jane@example.com",
  "resetCode": "963928"
}
```

### Response (200)
```json
{
  "status": "success",
  "data": {
    "resetToken": "<resetToken>"
  }
}
```

### Screen
📱 **VerifyResetCodeScreen** - `lib/features/auth/ui/screens/verify_reset_code_screen.dart`
- Input: 6-digit reset code
- Validation: Code format (numeric, exactly 6 digits)
- Uses: Email from previous screen (passed as parameter)
- Returns: resetToken for next step

---

## 5️⃣ إعادة تعيين كلمة المرور (Reset Password)

### Endpoint
```
PATCH /auth/resetPassword
```

### Request Body
```json
{
  "password": "newpassword123",
  "passwordConfirm": "newpassword123",
  "resetToken": "<token>"
}
```

### Response (200)
```json
{
  "status": "success",
  "message": "Password reset successfully"
}
```

### Screen
📱 **ForgotPasswordScreen** (Step 2) - `lib/features/auth/ui/screens/forgot_password_screen.dart`
- Shows after code verification
- Input fields: new password, confirm password
- Uses: resetToken from code verification
- Navigation: Redirects to login after success

---

## 6️⃣ تحديث كلمة المرور (Update Password)

### Endpoint
```
PATCH /auth/updateMyPassword
```

### Headers
```
Authorization: Bearer <jwt>
```

### Request Body
```json
{
  "passwordCurrent": "oldpassword123",
  "password": "newpassword123"
}
```

### Response (200)
```json
{
  "status": "success",
  "message": "Password updated successfully"
}
```

### Implementation Note
- Would be accessed from User Settings/Profile screen
- Requires authentication token
- Located in: Profile Cubit or separate Security Cubit

---

## 7️⃣ تحديث التوكن (Refresh Token)

### Endpoint
```
POST /auth/refreshToken
```

### Request Body
```json
{
  "refreshToken": "<refreshToken>"
}
```

### Response (200)
```json
{
  "status": "success",
  "data": {
    "token": "<newJwt>",
    "refreshToken": "<newRefreshToken>"
  }
}
```

### Implementation Note
- Called automatically before token expiration
- Handles in: API interceptor or token manager service
- Transparent to user

---

## 8️⃣ إدارة الجلسات (Get Sessions)

### Endpoint
```
GET /auth/sessions
```

### Headers
```
Authorization: Bearer <jwt>
```

### Query Parameters
```
page=1&limit=20
```

### Response (200)
```json
{
  "status": "success",
  "data": {
    "sessions": [
      {
        "id": 1,
        "deviceName": "iPhone 13",
        "userAgent": "Mozilla/5.0...",
        "lastActivity": "2024-01-15T10:30:00Z"
      }
    ],
    "pagination": { ... }
  }
}
```

### Screen
📱 **SessionsScreen** - `lib/features/auth/ui/screens/sessions_screen.dart`
- Displays list of active sessions/devices
- Shows device name, user agent, last activity
- Allows deletion of individual sessions
- Provides "Logout from all devices" option

---

## 9️⃣ حذف جلسة معينة (Delete Session)

### Endpoint
```
DELETE /auth/sessions/:sessionId
```

### Headers
```
Authorization: Bearer <jwt>
```

### Response (200)
```json
{
  "status": "success",
  "message": "Session revoked successfully"
}
```

### Implementation
- Called from: SessionsScreen
- Method: `AuthCubit.deleteSession(token, sessionId)`
- Action: Removes specific device from authenticated user's sessions

---

## 🔟 تسجيل الخروج (Logout)

### Endpoint
```
GET /auth/logout
```

### Headers
```
Authorization: Bearer <jwt>
```

### Response (200)
```json
{
  "status": "success",
  "message": "Logged out successfully"
}
```

### Implementation
- Called from: Any screen via menu or profile
- Invalidates current session
- Clears local auth data (tokens, user info)
- Redirects to login screen

---

## 1️⃣1️⃣ تسجيل الخروج من جميع الأجهزة (Logout All)

### Endpoint
```
POST /auth/logout-all
```

### Headers
```
Authorization: Bearer <jwt>
```

### Response (200)
```json
{
  "status": "success",
  "message": "Logged out from all devices"
}
```

### Implementation
- Called from: SessionsScreen via menu or confirmation
- Invalidates all refresh tokens
- Requires re-login on all devices
- Most secure option for account protection

---

## 🏗️ Architecture Flow

```
┌─────────────────────────────────────────────────────────┐
│                   AUTH FEATURE FLOW                       │
├─────────────────────────────────────────────────────────┤
│                                                             │
│  LoginScreen ──────────────────────────► AuthCubit        │
│  SignupScreen ─────────► AuthRepository ──┤               │
│  ForgotPasswordScreen                      ├─► Dio (API)  │
│  VerifyResetCodeScreen ─────────────────┘                 │
│  SessionsScreen                                             │
│                                                             │
│  ┌─────────────────────────────────────────┐               │
│  │ AuthCubit States:                       │               │
│  │ - initial                               │               │
│  │ - loading                               │               │
│  │ - authenticated                         │               │
│  │ - resetCodeSent                         │               │
│  │ - resetCodeVerified                     │               │
│  │ - passwordReset                         │               │
│  │ - sessionsLoaded                        │               │
│  │ - sessionDeleted                        │               │
│  │ - loggedOut                             │               │
│  │ - error                                 │               │
│  └─────────────────────────────────────────┘               │
│                                                             │
└─────────────────────────────────────────────────────────┘
```

---

## 📱 Screen Navigation Map

```
LoginScreen
  ├─ [Signup Link] → SignupScreen
  └─ [Forgot Password] → ForgotPasswordScreen
       └─ [Send Code] → VerifyResetCodeScreen
            └─ [Verify Code] → ForgotPasswordScreen (Step 2: Reset)
                 └─ [Success] → LoginScreen

SessionsScreen (from Profile)
  ├─ [Delete Session] → Delete via API
  └─ [Logout All] → Confirmation → Logout via API
```

---

## 🔐 Token Management

| Operation | Storage | Expiration | Action |
|-----------|---------|-----------|--------|
| Login | SharedPreferences | Session | Stored after login |
| Refresh | Automatic | ~7 days | Called before expiry |
| Logout | Clear | Immediate | Remove from storage |
| Update Password | Keep | Updated | New token issued |

---

## ✅ Cubit Methods Available

```dart
// Auth Operations
Future<void> signup({required String name, email, password, passwordConfirm})
Future<void> login({required String email, password})

// Password Reset
Future<void> forgotPassword({required String email})
Future<void> checkResetCode({required String email, resetCode})
Future<void> resetPassword({required String password, passwordConfirm, resetToken})

// Session Management
Future<void> getSessions({required String token, int page, limit})
Future<void> deleteSession({required String token, int sessionId})

// Logout
Future<void> logout({required String token})
Future<void> logoutAll({required String token})

// Helper
void reset()
```

---

## 🚀 Next Steps

1. ✅ Run `flutter pub run build_runner build --delete-conflicting-outputs`
2. ✅ Add auth routes to app router
3. ✅ Integrate with local storage (tokens)
4. ✅ Setup API interceptors for token refresh
5. ✅ Add form validations
6. ✅ Setup password requirements UI feedback
