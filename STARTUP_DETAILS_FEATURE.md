# إضافة شاشة تفاصيل الشركة - Startup Details Screen

## 🎯 الوصف
تم تطبيق ميزة جديدة تسمح للمستخدم بالضغط على أي شركة مميزة في شاشة الاستكشاف (Explore)، مما ينقله إلى شاشة تفاصيل الشركة الكاملة مع عرض جميع المعلومات والمميزات.

## ✅ التغييرات المنجزة

### 1. **تحديث شاشة الاستكشاف (Explore Screen)**
📁 `lib/features/explore/ui/screens/explore_screen.dart`

**التحسينات:**
- ✅ إضافة `onTap` handler لبطاقات الشركات المميزة (Featured Companies)
- ✅ إضافة `onTap` handler لبطاقات الشركات في قائمة الأحدث (Latest Companies)
- ✅ عند الضغط على أي شركة:
  - يتم تحميل تفاصيل الشركة من الـ Cubit
  - يتم الانتقال إلى `StartupProfileScreen` مع الحفاظ على حالة الـ Cubit
  - يتم عرض شاشة جديدة بـ push navigation (يمكن العودة للخلف)

```dart
StartupCardWidget(
  startup: item,
  onTap: () {
    // تحميل تفاصيل الشركة
    context.read<StartupCubit>().loadStartupDetails(item.id);
    // الانتقال إلى شاشة التفاصيل
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<StartupCubit>(),
          child: const StartupProfileView(),
        ),
      ),
    );
  },
)
```

### 2. **تحديث شاشة تفاصيل الشركة (Startup Profile Screen)**
📁 `lib/features/startup_profile/ui/screens/startup_profile_screen.dart`

**التحسينات:**
- ✅ إضافة زر Share (مشاركة) بجانب زر Follow
- ✅ تحسين الـ UI مع:
  - Back button مع تأثير شفاف
  - Share button لمشاركة معلومات الشركة
  - Follow/Following button لمتابعة الشركة
  
**الزر Share يعرض:**
```
- اسم الشركة
- وصف الشركة (نبذة عن الشركة)
- الموقع الإلكتروني للشركة
```

### 3. **تحديث تسميات Tabs**
- ✅ Tab 1: "النبذة" (About)
- ✅ Tab 2: "المميزات" (Features)
- ✅ Tab 3: "الأخبار" (News)
- ✅ Tab 4: "التواصل" (Contact)

تتغير التسميات حسب اللغة المختارة (العربية/الإنجليزية) تلقائياً.

### 4. **نظام الملاحة والانتقال**
```
Explore Screen
    ↓
[Click on Company Card]
    ↓
Load Startup Details via Cubit
    ↓
Startup Profile Screen
    ├── Header (Image + Logo)
    ├── Tabs (About | Features | News | Contact)
    └── Content based on selected tab
```

## 📊 البيانات المعروضة

### في شاشة التفاصيل:
1. **الرأس (Header):**
   - صورة الغلاف (Cover Image)
   - شعار الشركة (Logo)
   - اسم الشركة
   - زر المتابعة (Follow/Following)
   - زر المشاركة (Share)

2. **تب النبذة (About Tab):**
   - التقييم والآراء
   - وصف الشركة
   - المعلومات الأساسية:
     - تاريخ التأسيس
     - الموقع الجغرافي
     - البريد الإلكتروني
     - الموقع الإلكتروني
     - رقم الهاتف

3. **تب المميزات (Features Tab):**
   - قائمة بمميزات الشركة
   - أيقونة تحقق (✓) لكل ميزة

4. **تب الأخبار (News Tab):**
   - آخر الأخبار والتحديثات
   - تاريخ النشر

5. **تب التواصل (Contact Tab):**
   - بيانات جهات الاتصال
   - أرقام الهواتف
   - البريد الإلكتروني

## 🔧 التغييرات التقنية

### المكتبات المستخدمة:
- ✅ GetIt - للـ Dependency Injection
- ✅ Flutter BLoC - لإدارة الحالة
- ✅ Freezed - لـ immutable data classes
- ✅ Flutter Screenutil - للتجاوب مع أحجام الشاشات

### الـ Navigation Flow:
```
ScreenUtilInit
  └── BlocProvider<ProfileCubit>
      └── BlocBuilder<ProfileCubit>
          └── MaterialApp
              └── MainScreen
                  ├── IndexedStack (6 screens)
                  │   └── ExploreScreen
                  │       ├── FeaturedCompanies ListView
                  │       └── LatestCompanies GridView
                  │           └── [onTap] → Navigator.push()
                  │               └── StartupProfileScreen
                  │                   ├── NestedScrollView
                  │                   ├── SliverAppBar
                  │                   ├── TabBar
                  │                   └── TabBarView
                  │                       ├── AboutTabWidget
                  │                       ├── FeaturesTabWidget
                  │                       ├── NewsTabWidget
                  │                       └── ContactTabWidget
```

## 🌍 المتطلبات المحلية

تم استخدام strings محلية موجودة بالفعل:
- `about` - "النبذة"
- `news` - "الأخبار"
- `features` - "المميزات"

## 📁 الملفات المعدلة

1. ✅ `lib/features/explore/ui/screens/explore_screen.dart`
   - إضافة onTap handlers
   - إضافة imports جديدة

2. ✅ `lib/features/startup_profile/ui/screens/startup_profile_screen.dart`
   - إضافة زر Share
   - تحديث Tab labels للعربية

3. ✅ `lib/core/root/app_router.dart`
   - تنظيف الـ imports

4. ✅ `pubspec.yaml`
   - (بدون تغييرات إضافية جديدة)

## 🎨 واجهة المستخدم

### شاشة الاستكشاف (Explore):
- [✓] الشركات المميزة قابلة للنقر
- [✓] آخر الشركات قابلة للنقر
- [✓] تأثيرات بصرية عند الضغط

### شاشة التفاصيل (Startup Profile):
- [✓] رأس ملفت مع صورة الغلاف
- [✓] شعار الشركة بتصميم احترافي
- [✓] أزرار الإجراءات (Follow + Share)
- [✓] Tabs قابلة للتنقل بسهولة
- [✓] محتوى منفصل لكل تب
- [✓] دعم RTL للغة العربية

## ✨ المميزات الإضافية

1. **تحميل البيانات الديناميكي**
   - البيانات تُحمل عند فتح الشركة
   - شاشة تحميل احترافية

2. **معالجة الأخطاء**
   - عرض رسالة خطأ واضحة
   - زر "إعادة المحاولة" في حالة الفشل

3. **الملاحة السلسة**
   - يمكن العودة للخلف بسهولة
   - الحالة محفوظة أثناء التنقل

4. **الدعم متعدد اللغات**
   - العربية (RTL)
   - الإنجليزية (LTR)
   - الـ UI يتأقلم تلقائياً

## 🧪 الاختبار

للتحقق من أن كل شيء يعمل بشكل صحيح:

1. اذهب إلى شاشة الاستكشاف (Explore)
2. انقر على أي شركة من الشركات المميزة
3. يجب أن تفتح شاشة تفاصيل الشركة
4. جرب:
   - النقر على أزرار Tabs المختلفة
   - النقر على زر Follow لمتابعة الشركة
   - النقر على زر Share لمشاركة المعلومات
   - العودة للخلف باستخدام زر الرجوع

## 📝 الملاحظات

- جميع البيانات تُحمل من المستودع (Repository) الذي يستخدم mock data حالياً
- عند الاتصال برابط API حقيقي، المنطق سيعمل بدون تعديل
- الـ UI متصمم ليكون متجاوباً مع جميع أحجام الشاشات

## 🚀 الخطوات التالية (اختياري)

1. إضافة معلومات إضافية عن الشركة
2. إضافة معرض صور (Gallery) للشركة
3. إضافة تقييم الشركة من المستخدمين
4. إضافة تعليقات على الأخبار
5. ربط بـ Favorites لحفظ الشركات المفضلة

---

**حالة المشروع: ✅ جاهز**
**التاريخ:** 31 مارس 2026
**الإصدار:** 1.0.0
