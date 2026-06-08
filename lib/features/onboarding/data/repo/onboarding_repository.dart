import '../models/onboarding_model.dart';

class OnboardingRepository {
  List<OnboardingItem> getOnboardingItems() {
    return const [
      OnboardingItem(
        image: 'assets/images/onboarding1.png',
        title: 'اكتشف الشركات الناشئة',
        description: 'تصفح العديد من الشكات الناشئة المبتكرة في مختلف المجالات',
      ),
      OnboardingItem(
        image: 'assets/images/onboarding2.png',
        title: 'تابع أخر الاخبار',
        description:
            'كن اول من يعرف عن أحدث التطورات والفرص الجديدة للشركات التي تهمك',
      ),
      OnboardingItem(
        image: 'assets/images/onboarding3.png',
        title: 'تواصل مباشرة',
        description:
            'تواصل مع الشركات الناشئة مباشرة عبر واتساب او وسائل الاتصال المدمجة',
      ),
    ];
  }
}
