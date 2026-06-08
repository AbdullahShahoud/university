import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/company_details_widgets.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final CompanyDetailsData company;

  const CompanyDetailsScreen({super.key, required this.company});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  late ScrollController _scrollController;
  bool _isHeaderTransparent = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final currenIsTransparent = _scrollController.offset < 150;
    if (currenIsTransparent != _isHeaderTransparent) {
      setState(() {
        _isHeaderTransparent = currenIsTransparent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: AnimatedBuilder(
          animation: _scrollController,
          builder: (context, _) {
            return AppBar(
              backgroundColor: _isHeaderTransparent
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.9),
              elevation: _isHeaderTransparent ? 0 : 4,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: _isHeaderTransparent
                        ? Colors.white.withOpacity(0.2)
                        : Colors.grey.shade100,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: _isHeaderTransparent
                        ? Colors.white
                        : Colors.grey[800],
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: _isHeaderTransparent
                        ? Colors.white.withOpacity(0.2)
                        : Colors.grey.shade100,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                      color: _isHeaderTransparent
                          ? Colors.white
                          : Colors.grey[800],
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Hero Header
            HeroHeaderSection(company: widget.company),
            // Profile Info
            ProfileInfoSection(company: widget.company),
            // Stats Row
            StatsRowSection(company: widget.company),
            // Tabs
            TabsSection(company: widget.company),
            // About Content
            SizedBox(height: 24.h),
          ],
        ),
      ),
      bottomNavigationBar: BottomActionButtons(company: widget.company),
    );
  }
}

class CompanyDetailsData {
  final String id;
  final String name;
  final String heroImage;
  final String logoImage;
  final String category;
  final String categoryIcon;
  final int followers;
  final int news;
  final double rating;
  final String description;
  final String vision;
  final String mission;
  final String featuredImage;
  final String whatsappNumber;
  final String phoneNumber;

  CompanyDetailsData({
    required this.id,
    required this.name,
    required this.heroImage,
    required this.logoImage,
    required this.category,
    required this.categoryIcon,
    required this.followers,
    required this.news,
    required this.rating,
    required this.description,
    required this.vision,
    required this.mission,
    required this.featuredImage,
    required this.whatsappNumber,
    required this.phoneNumber,
  });
}
