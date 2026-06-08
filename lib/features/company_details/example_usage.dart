import 'package:flutter/material.dart';
import 'ui/screens/company_details_screen.dart';

// Example usage of CompanyDetailsScreen
class CompanyDetailsExample {
  static void openCompanyDetails(
    BuildContext context, {
    required String companyId,
  }) {
    // Create sample company data
    final companyData = CompanyDetailsData(
      id: companyId,
      name: 'أورورا للحلول الذكية',
      heroImage:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCl30AeOLiIR-eowZT70sIh9tJB2B2CaY68RxIgZNQW3InukeAPePxzmlJXkzdR7HRILmoOTYj_M1J3D-URH7v6shPI4JTNDbZg0RhcrDQ72_ZWcQb58-3qZaFFcTS5VDUn8pvmOHDnj689v4Yap9BkJcLc45fThkEwPlxriJgZLhX3F50Gi7YDVbW-8W1hLIHdHwm5_3Nh-djLDA8j1v2dJtUloTU4vSXprqy8bxKLRThsTd_zlgZs-SmTtT04flRME3OYx3fq42I',
      logoImage:
          'https://lh3.googleusercontent.com/aida/ADBb0ugK_ES-i1peMkqqcwcOM1OR36nih9WAKWv1RAyuWe79LToJBiyAtgWD2-cVOkCc73jE_gnM2iUFMlMCi-N1CqgiNzz8z3HcoFf0m6S6BzpSqCmY3StU7t2liY5HH01wJXiy9SxfqqWXCDNBQS3LXxUxVQiEolmVv7rpL84LTizPgg9gh27uEIGAbhqsch7GyolFEt3CpVK9aawo4xH8EUPcb6dhs4KKuzPqR1QCYVqairLWt7xdRtcS0Q',
      category: 'تكنولوجيا المعلومات والبرمجيات',
      categoryIcon: 'memory',
      followers: 12000,
      news: 85,
      rating: 4.8,
      description:
          'تعتبر أورورا للحلول الذكية رائدة في مجال التحول الرقمي، حيث نركز على تطوير حلول مبتكرة تعتمد على الذكاء الاصطناعي لتمكين المؤسسات من تحسين كفاءتها التشغيلية. نحن نؤمن بأن التكنولوجيا هي المفتاح لمستقبل أكثر استدامة.',
      vision:
          'أن نصبح الشريك التقني الأول عالمياً في تقديم حلول الذكاء الاصطناعي المتكاملة.',
      mission:
          'تمكين الشركات من خلال الابتكار الرقمي المستمر وتوفير تجارب مستخدم استثنائية.',
      featuredImage:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBtvk9Bq1P530LZC-NUagvNsSOEcZ7vIUv53fpNmXKKpFHqSkT0vI4BJNQB6yGXx6sDftDLp-GRKNDVAEh-7izNUAWi6MHNfJ0OuSPAoh7HQj4tlhCuQoyS3-WUuO8hVmlv7dgkNY0xx7RInAaL7AEUIKgdP17vcI1gVc_eTaJhjgYDRGVBo6R9NUrMrvLEUgzR1NrdoHZNanmZlaKRDfsp0V0FJm_FkhS4FX3RdP-xScmFC7t9uiN0xmH2avlGJXjpJ1J3aLd1Wcw',
      whatsappNumber: '+966501234567',
      phoneNumber: '+966112345678',
    );

    // Navigate to the screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyDetailsScreen(company: companyData),
      ),
    );
  }
}
