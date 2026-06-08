import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../logic/cubit/onboarding_cubit.dart';
import '../../data/models/onboarding_model.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingView();
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingLoaded) {
          return Scaffold(
            backgroundColor: colors.background,
            body: SafeArea(
              child: Column(
                children: [
                  // Skip button
                  Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      width: 80.w,
                      height: 40.h,
                      child: AppButton(
                        onPressed: () {
                          context.read<OnboardingCubit>().skipToEnd();
                        },
                        text: 'تخطي',
                        backgroundColor: Colors.transparent,
                        textColor: colors.textSecondary,
                      ),
                    ),
                  ),

                  // Page view
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        return OnboardingPage(item: state.items[index]);
                      },
                    ),
                  ),

                  // Bottom section
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        // Dots indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            state.items.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              height: 8.h,
                              width: _currentPage == index ? 24.w : 8.w,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? colors.primary
                                    : colors.textSecondary.withValues(
                                        alpha: 0.3,
                                      ),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // Buttons
                        Row(
                          children: [
                            if (_currentPage > 0)
                              Expanded(
                                child: AppButton(
                                  onPressed: () {
                                    context
                                        .read<OnboardingCubit>()
                                        .previousPage(_currentPage);
                                  },
                                  text: 'السابق',
                                  backgroundColor: Colors.transparent,
                                  textColor: colors.primary,
                                ),
                              ),
                            if (_currentPage > 0) SizedBox(width: 16.w),
                            Expanded(
                              flex: _currentPage == 0 ? 1 : 2,
                              child: AppButton(
                                onPressed: () {
                                  if (_currentPage == state.items.length - 1) {
                                    context.read<OnboardingCubit>().skipToEnd();
                                  } else {
                                    context.read<OnboardingCubit>().nextPage(
                                      _currentPage,
                                      state.items.length,
                                    );
                                  }
                                },
                                text: _currentPage == state.items.length - 1
                                    ? 'ابدأ'
                                    : 'التالي',
                                backgroundColor: colors.primary,
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Image.asset(item.image, height: 300.h, fit: BoxFit.contain),

          SizedBox(height: 48.h),

          // Title
          Text(
            item.title,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 16.h),

          // Description
          Text(
            item.description,
            style: TextStyle(
              fontSize: 16.sp,
              color: colors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
