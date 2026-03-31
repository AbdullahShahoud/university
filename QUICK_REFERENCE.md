# Quick Reference Card

## 📌 Common Tasks

### 1. Show Success Feedback to User
```dart
context.showSuccessSnackBar('Action completed!');
```

### 2. Show Error Message
```dart
context.showErrorSnackBar('Something went wrong. Please try again.');
```

### 3. Ask User for Confirmation
```dart
final confirmed = await context.showConfirmDialog(
  title: 'Delete Item',
  message: 'Are you sure you want to delete this?',
);
if (confirmed) {
  // Do something
}
```

### 4. Show Loading Dialog
```dart
context.showLoadingDialog('Loading...');
// Later:
Navigator.pop(context); // Close dialog
```

### 5. Use Loading Button
```dart
LoadingButton(
  label: 'Save',
  isLoading: state.isSaving,
  onPressed: () => cubit.save(),
)
```

### 6. Handle Loading State
```dart
if (state.isLoading) {
  return const Center(child: CircularProgressIndicator());
}
```

### 7. Handle Empty State
```dart
if (state.items?.isEmpty ?? true) {
  return EmptyStateWidget(
    title: 'No items found',
    message: 'Try creating a new one',
    actionLabel: 'Create',
    onAction: () => cubit.create(),
  );
}
```

### 8. Handle Error State
```dart
if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
  return ErrorStateWidget(
    message: state.errorMessage!,
    onRetry: () => cubit.retry(),
  );
}
```

### 9. Navigate to Another Tab
```dart
// From any screen:
context.read<NavigationCubit>().changeTab(0); // Tab 0: Explore
context.read<NavigationCubit>().changeTab(1); // Tab 1: Startup
context.read<NavigationCubit>().changeTab(2); // Tab 2: News
context.read<NavigationCubit>().changeTab(3); // Tab 3: Favorites
context.read<NavigationCubit>().changeTab(4); // Tab 4: Notifications
context.read<NavigationCubit>().changeTab(5); // Tab 5: Profile
```

### 10. Get Current Theme Colors
```dart
final colors = context.colors;
Container(
  color: colors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: colors.onPrimary),
  ),
)
```

### 11. Get Current Language
```dart
final locale = context.watch<ProfileCubit>().state.currentLanguage;
final isArabic = locale == 'ar';
```

### 12. Handle Side Effects with BlocListener
```dart
BlocListener<MyCubit, MyState>(
  listener: (context, state) {
    if (state.errorMessage != null) {
      context.showErrorSnackBar(state.errorMessage!);
    }
  },
  child: BlocBuilder<MyCubit, MyState>(
    builder: (context, state) {
      // Return UI
    },
  ),
)
```

---

## 🎨 UI Components Quick Guide

### LoadingButton
```dart
LoadingButton(
  label: 'Submit',
  isLoading: cubit.isSaving,
  onPressed: () => cubit.save(),
  disabled: !formValid,
)
```

### EmptyStateWidget
```dart
EmptyStateWidget(
  icon: Icons.inbox,
  title: 'No Items',
  message: 'You haven\'t added any items yet',
  actionLabel: 'Add Item',
  onAction: () {},
)
```

### ErrorStateWidget
```dart
ErrorStateWidget(
  message: 'Failed to load data',
  onRetry: () => cubit.retry(),
)
```

### LoadingOverlay
```dart
Stack(
  children: [
    YourContent(),
    if (state.isLoading) const LoadingOverlay(),
  ],
)
```

---

## 🗂️ Navigation Tabs

| Tab | Index | Screen | Cubit |
|-----|-------|--------|-------|
| 0 | 0 | ExploreScreen | ExploreCubit |
| 1 | 1 | StartupProfileScreen | StartupCubit |
| 2 | 2 | NewsScreen | NewsCubit |
| 3 | 3 | FavoritesScreen | FavoritesCubit |
| 4 | 4 | NotificationsScreen | NotificationsCubit |
| 5 | 5 | ProfileScreen | ProfileCubit |

---

## 🎯 State Management Pattern

```
┌─────────────────┐
│   Repository    │ (Mock or real API)
└────────┬────────┘
         │
    ┌────▼────┐
    │ApiResult│ (Success/Error wrapper)
    └────┬────┘
         │
    ┌────▼─────┐
    │  Cubit   │ (State management)
    └────┬─────┘
         │
    ┌────▼──────┐
    │    UI     │ (Screens & Widgets)
    └───────────┘
```

---

## 📱 Responsive Design

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Responsive sizing
Container(
  width: 300.w,      // Screen width responsive
  height: 200.h,     // Screen height responsive
  padding: EdgeInsets.all(16.w),
  child: Text(
    'Hello',
    style: TextStyle(
      fontSize: 16.sp,  // Font size responsive
    ),
  ),
)
```

---

## 🌍 Localization

```dart
// Use localization keys in UI
Text(AppLocalizations.of(context)!.explore) // Translates to "استكشاف" in Arabic

// Get locale
final locale = context.watch<ProfileCubit>().state.currentLanguage;

// Change language
context.read<ProfileCubit>().changeLanguage('ar');
```

---

## 🌓 Dark/Light Mode

```dart
// Get colors based on current theme
final colors = context.colors;

// Colors object has:
// - primary (brand color)
// - onPrimary (text on brand color)
// - surface (background)
// - onSurface (text on background)
// - error
// - success
// - warning
// - info

Container(
  color: colors.surface,
  child: Text(
    'Themed Text',
    style: TextStyle(color: colors.onSurface),
  ),
)
```

---

## 🧪 Testing Commands

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/features/notifications/logic/notifications_cubit_test.dart

# Run with coverage
flutter test --coverage

# Watch mode (rerun on changes)
flutter test --watch
```

---

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── widgets/
│   │   └── ux_helpers.dart          ← All UX utilities
│   ├── theme/
│   │   └── theme_extensions.dart    ← Color theming
│   ├── networking/
│   └── ...
├── features/
│   ├── explore/
│   │   ├── logic/
│   │   │   └── cubit/
│   │   ├── data/
│   │   └── ui/
│   ├── notifications/               ← Enhanced ✅
│   ├── news/
│   ├── favorites/
│   ├── profile/
│   └── startup_profile/
└── main.dart

test/
├── features/
│   ├── notifications/
│   │   └── notifications_cubit_test.dart
│   └── ...
└── ...
```

---

## ⚡ Common Issues & Solutions

### Issue: Snackbar not showing?
**Solution:** Check if `removeCurrentSnackBar()` is being called

### Issue: Colors not updating in dark mode?
**Solution:** Use `context.colors` instead of hardcoded colors

### Issue: Navigation not updating UI?
**Solution:** Make sure you're using `changeTab()` from NavigationCubit

### Issue: Freezed code not generated?
**Solution:** Run `dart run build_runner build --delete-conflicting-outputs`

### Issue: Text not translating?
**Solution:** Check localization keys exist in arb files

---

## 📚 Full Documentation

- **UX_ENHANCEMENT_GUIDE.md** - Complete UX implementation guide
- **NAVIGATION_INTEGRATION_GUIDE.md** - Navigation flows and integration
- **TESTING_ACCESSIBILITY_PRODUCTION_GUIDE.md** - Testing and production readiness
- **PROJECT_COMPLETION_SUMMARY.md** - Overview of all changes

---

## 🚀 Build & Run Commands

```bash
# Get clean dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Debug
flutter run -v

# Build release APK
flutter build apk --release

# Build release AAB (for Play Store)
flutter build appbundle --release

# Clean everything
flutter clean && flutter pub get && dart run build_runner build
```

---

## 📌 Remember

✅ Always handle 4 states: Loading, Success, Error, Empty
✅ Show user feedback for all actions
✅ Use UX helpers for consistent experience
✅ Support dark/light mode
✅ Support both English and Arabic
✅ Make UI responsive
✅ Write tests for new features
✅ Follow Clean Architecture pattern

---

**Last Updated:** March 31, 2026
**Version:** 1.0.0
