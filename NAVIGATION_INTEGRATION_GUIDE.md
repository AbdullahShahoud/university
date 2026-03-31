# Navigation & Integration Complete Guide

## Overview
Complete guide for integrating all features with smooth navigation and proper state management across the University App.

---

## 1. CURRENT NAVIGATION STRUCTURE

### App Architecture
```
AppRoot (ScreenUtilInit + BlocProvider)
├── ProfileCubit (Theme & Language Management)
└── MainScreen (IndexedStack Navigation)
    ├── NavigationCubit (Tab Control)
    └── BottomNavigationBar (6 Tabs)
        ├── 0: ExploreScreen
        ├── 1: StartupProfileScreen  
        ├── 2: NewsScreen
        ├── 3: FavoritesScreen
        ├── 4: NotificationsScreen
        └── 5: ProfileScreen
```

---

## 2. SCREEN NAVIGATION FLOWS

### Explore Flow ➡️ Startup Details
```
ExploreScreen
├── Search startup
├── Select featured/latest startup
├── Navigate to StartupProfileScreen
└── Show startup details with tabs
    ├── About
    ├── Features
    ├── News
    └── Contacts
```

**Implementation:**
```dart
// In ExploreScreen
StartupCardWidget(
  startup: startup,
  onTap: () {
    // Navigate to StartupProfile screen (Tab 1)
    context.read<NavigationCubit>().changeTab(1);
    // Pass startup ID to cubit
    context.read<StartupCubit>().loadStartupDetails(startup.id);
  },
)
```

### Startup Details ➡️ News Detail
```
StartupProfileScreen (Tab 1)
├── Show startup overview
├── View news tab
└── Tap news article
    └── Navigate to NewsScreen and show detail
```

**Implementation:**
```dart
// In StartupProfileScreen NewsTabWidget
NewsCard(
  news: news,
  onTap: () {
    context.read<NavigationCubit>().changeTab(2); // News Tab
    context.read<NewsCubit>().loadNewsDetail(news.id);
  },
)
```

### Notifications ➡️ Startup/News
```
NotificationsScreen (Tab 4)
├── Tap notification
└── Navigate to related content
    ├── If startup notification → StartupProfileScreen
    ├── If news notification → NewsScreen
    └── If message notification → Profile/Chat
```

**Implementation:**
```dart
// In NotificationsScreen
NotificationTile(
  notification: notification,
  onTap: () {
    if (notification.type == 'follow') {
      context.read<StartupCubit>().loadStartupDetails(notification.relatedId!);
      context.read<NavigationCubit>().changeTab(1);
    } else if (notification.type == 'update') {
      context.read<NewsCubit>().loadNewsDetail(notification.relatedId!);
      context.read<NavigationCubit>().changeTab(2);
    }
  },
)
```

### Tab Navigation
```
User taps bottom nav tab
├── NavigationCubit.changeTab(index)
├── IndexedStack switches page
└── Screen loads data (via listener on init)
```

---

## 3. STATE PERSISTENCE

### What Persists Across Tabs
- ✅ ProfileCubit (Theme, Language) - Saved to SharedPreferences
- ✅ FavoritesCubit (Favorites list) - Saved to SharedPreferences
- ✅ NavigationCubit (Current tab) - Reset on app restart

### What Resets
- ❌ ExploreScreen search filters - Reset when leaving tab
- ❌ NewsScreen filters - Reset when leaving tab
- ✅ NotificationsScreen data - Persists (list of notifications)

**To Add Persistence:**

```dart
// In cubit
final prefs = await SharedPreferences.getInstance();
final savedData = prefs.getStringList('key');

// Save data
await prefs.setStringList('key', data);
```

---

## 4. DEEP LINKING (FUTURE)

### Prepare for Deep Links:

```dart
// In app_router.dart
static final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/startup/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return StartupProfileScreen(startupId: id);
      },
    ),
    GoRoute(
      path: '/news/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return NewsDetailScreen(newsId: id);
      },
    ),
  ],
);
```

**Current:** Using IndexedStack navigation
**Future:** Migrate to GoRouter for deep linking support

---

## 5. NAVIGATION CUBIT

### Current Implementation:

```dart
// lib/core/root/navigation_cubit.dart
@freezed
class NavigationState with _$NavigationState {
  const factory NavigationState({
    @Default(0) int currentIndex,
  }) = _NavigationState;
}

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  void changeTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void resetTab() {
    emit(const NavigationState());
  }
}
```

### Usage:
```dart
// Change tab
context.read<NavigationCubit>().changeTab(1);

// Reset to home
context.read<NavigationCubit>().resetTab();
```

---

## 6. INTER-FEATURE COMMUNICATION

### Pattern 1: Via Navigation + Cubit

```dart
// From Feature A, navigate and initialize Feature B
context.read<NavigationCubit>().changeTab(1); // Go to Feature B
context.read<FeatureBCubit>().loadData(dataId);
```

### Pattern 2: Via Shared Cubit

```dart
// Create shared cubit at root level
BlocProvider(
  create: (_) => SharedDataCubit(),
  child: MainScreen(),
)

// Use in any feature
context.read<SharedDataCubit>().setSelectedItem(item);
```

### Pattern 3: Event Bus (Advanced)

```dart
// Single event bus for app-wide events
class AppEventBus {
  static final AppEventBus _instance = AppEventBus._();
  
  factory AppEventBus() => _instance;
  AppEventBus._();
  
  final _eventController = StreamController<AppEvent>.broadcast();
  
  Stream<AppEvent> get events => _eventController.stream;
  
  void emit(AppEvent event) => _eventController.add(event);
}

// Use
AppEventBus().emit(StartupSelectedEvent(startupId));
// Listen
AppEventBus().events.listen((event) {
  if (event is StartupSelectedEvent) {
    // Handle
  }
});
```

---

## 7. LOADING & INITIALIZATION

### App Startup Flow:

```dart
AppRoot
├── ScreenUtilInit
├── BlocProvider<ProfileCubit>
│   └── loadSettings() ← Load theme, language
├── MaterialApp with theme/locale
└── BlocProvider<NavigationCubit>
    └── MainScreen
        └── IndexedStack with all screens
            └── Each screen has own BlocProvider
                └── Load initial data
```

### Screen Initialization:

```dart
// Best Practice: Load in BlocProvider.create()
class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExploreCubit(ExploreRepositoryImpl(Dio()))
        ..loadInitialData(), // Load on create
      child: const _ExploreView(),
    );
  }
}
```

---

## 8. ERROR RECOVERY

### Network Error:

```dart
// User sees error state
ErrorStateWidget(
  message: 'No internet connection',
  onRetry: () => cubit.retry(), // Retry same request
)
```

### Server Error:

```dart
// User sees specific error
if (state.errorMessage == 'Not Found') {
  EmptyStateWidget(
    title: 'Item not found',
    onAction: () => context.read<NavigationCubit>().changeTab(0),
  );
}
```

### Timeout:

```dart
// Show timeout error with longer retry
context.showErrorSnackBar(
  'Request took too long. Check your connection.',
);
```

---

## 9. INTEGRATION CHECKLIST

### ✅ Navigation
- [x] BottomNavigationBar with 6 tabs
- [x] NavigationCubit controls tabs
- [x] MainScreen manages IndexedStack
- [x] Tab switching works smoothly

### ✅ Data Flow
- [x] ExploreScreen → StartupProfile
- [x] StartupProfile → NewsDetail  
- [x] Notifications → Related content
- [x] Favorites show/hide properly

### 🔄 Next: Enhanced Integration
- [ ] Pass startup/news ID when switching tabs
- [ ] Initialize detail screens with data
- [ ] Show loading state during navigation
- [ ] Handle navigation errors gracefully
- [ ] Implement undo/back navigation

### 📋 Future: Navigation Improvements
- [ ] Implement Go Router for deep linking
- [ ] Add route guard/auth checks
- [ ] Save navigation state on pause
- [ ] Handle app restart navigation

---

## 10. IMPLEMENTATION FOR SMOOTH FLOW

### Step 1: Update StartupCardWidget

```dart
// In explore_widgets.dart
GestureDetector(
  onTap: () {
    // Load startup details
    context.read<StartupCubit>().loadStartupDetails(startup.id);
    // Switch to tab 1
    context.read<NavigationCubit>().changeTab(1);
  },
  child: Card(...),
)
```

### Step 2: Update NewsCardWidget

```dart
// In startup_profile_widgets.dart
GestureDetector(
  onTap: () {
    // Load news detail
    context.read<NewsCubit>().loadNewsDetail(news.id);
    // Switch to news tab
    context.read<NavigationCubit>().changeTab(2);
  },
  child: Card(...),
)
```

### Step 3: Update NotificationTile

```dart
// In notifications_widgets.dart
GestureDetector(
  onTap: () {
    if (notification.relatedId != null) {
      if (notification.type == 'follow') {
        context.read<StartupCubit>().loadStartupDetails(notification.relatedId!);
        context.read<NavigationCubit>().changeTab(1);
      }
    }
  },
  child: Card(...),
)
```

---

## 11. TESTING NAVIGATION

### Manual Testing Checklist:

```
Explore Tab:
- [ ] Load startups successfully
- [ ] Search filters work
- [ ] Tap startup → goes to tab 1
- [ ] Tab 1 shows correct startup

News Tab:
- [ ] Load articles successfully
- [ ] Tap article → shows detail
- [ ] Mark as read works
- [ ] Back button returns to list

Notifications Tab:
- [ ] Load notifications
- [ ] Mark as read works
- [ ] Tap notification → navigates
- [ ] Delete works

Favorites Tab:
- [ ] Show favorites
- [ ] Add/remove works
- [ ] Share functionality

Profile Tab:
- [ ] Theme toggle works
- [ ] Language toggle works (en/ar)
- [ ] RTL switches work
```

---

## 12. RESPONSIVE NAVIGATION

### Tablet Support:

```dart
// In MainScreen
@override
Widget build(BuildContext context) {
  final isTablet = MediaQuery.of(context).size.width > 600;
  
  return Scaffold(
    body: isTablet
      ? Row(
          children: [
            NavigationRail(...), // Left nav
            Expanded(child: IndexedStack(...)),
          ],
        )
      : Scaffold(
          body: IndexedStack(...),
          bottomNavigationBar: BottomNavigationBar(...),
        ),
  );
}
```

---

## 13. PERSISTENCE ACROSS TABS

### Option 1: Keep State (Current)
- Screens keep data when switching tabs
- No reload on return
- Issue: Old data might be shown

### Option 2: Reload on Return
- Refresh data when returning to tab
- Always shows latest data
- Impact: Visible loading on return

### Recommended: Smart Reload

```dart
// In screen
bool _dataIsStale = false;

@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed) {
    if (_dataIsStale) {
      context.read<CubitType>().refresh();
      _dataIsStale = false;
    }
  }
}
```

---

## 14. SUMMARY

✅ **Current State:**
- Bottom navigation with 6 tabs
- NavigationCubit controls navigation
- IndexedStack manages screens
- Theme/language switching works

📋 **To Implement:**
- Navigation between related screens
- Pass data when navigating
- Show loading during navigation
- Handle back button properly

🎯 **Future Enhancements:**
- Deep linking with GoRouter
- Route guards/middleware
- Shared data management
- Navigation state persistence

---

## Quick Reference

```dart
// Change tab
context.read<NavigationCubit>().changeTab(1);

// Load data and navigate
context.read<StartupCubit>().loadStartupDetails(id);
context.read<NavigationCubit>().changeTab(1);

// Show feedback
context.showSuccessSnackBar('Item saved');
context.showErrorSnackBar('Operation failed');
```

---

## Files Structure

```
lib/
├── core/
│   ├── root/
│   │   ├── app_root.dart       (Main app setup)
│   │   ├── navigation_cubit.dart (Navigation state)
│   │   └── app_router.dart      (Screen definitions)
│   └── widgets/
│       └── ux_helpers.dart      (UX utilities)
├── features/
│   ├── explore/
│   ├── news/
│   ├── startup_profile/
│   ├── favorites/
│   ├── notifications/
│   └── profile/
```

---

For detailed UX implementation, see: `UX_ENHANCEMENT_GUIDE.md`
