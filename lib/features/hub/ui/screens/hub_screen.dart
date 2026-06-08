import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/background.dart';
import '../../data/models/hub_models.dart';
import '../../logic/cubit/hub_cubit.dart';
import 'hub_event_screen.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HubCubit>.value(
      value: RepositoryLocator.hubCubit,
      child: const _HubView(),
    );
  }
}

class _HubView extends StatefulWidget {
  const _HubView();

  @override
  State<_HubView> createState() => _HubViewState();
}

class _HubViewState extends State<_HubView> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Background(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(
                  child: Text(
                    'التدريب والتطوير',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'الفعاليات',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<HubCubit, HubState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.errorMessage != null) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<HubCubit>().reload(),
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _TrainingAndJobsTab(
                        colors: colors,
                        trainings: state.trainings,
                        jobs: state.jobs,
                      ),
                      _EventsTab(colors: colors, events: state.events),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainingAndJobsTab extends StatelessWidget {
  final dynamic colors;
  final List<HubTraining> trainings;
  final List<HubJob> jobs;

  const _TrainingAndJobsTab({
    required this.colors,
    required this.trainings,
    required this.jobs,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _SectionHeader(title: 'برامج التدريب', colors: colors),
              SizedBox(height: 12.h),
            ]),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 260.h,
            child: trainings.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد برامج تدريب متاحة حالياً',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemCount: trainings.length,
                    itemBuilder: (context, index) {
                      return _TrainingCard(
                        training: trainings[index],
                        colors: colors,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HubEventScreen(
                                event: HubEvent(
                                  id: trainings[index].id,
                                  title: trainings[index].title,
                                  description: trainings[index].description,
                                  category: '',
                                  type: 'تدريب',
                                  location: trainings[index].location,
                                  date: trainings[index].startDate,
                                  time: trainings[index].endDate,
                                  price: trainings[index].price,
                                  isOnline: false,
                                  status: trainings[index].status,
                                  tags: trainings[index].instructor,
                                  imageUrl: '',
                                  isFeatured: false,
                                  createdAt: trainings[index].createdAt,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _SectionHeader(title: 'الوظائف المتاحة', colors: colors),
              SizedBox(height: 12.h),
            ]),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: _JobCard(job: jobs[index], colors: colors),
            );
          }, childCount: jobs.length),
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: 80.h),
          sliver: SliverToBoxAdapter(child: SizedBox.shrink()),
        ),
      ],
    );
  }
}

class _EventsTab extends StatelessWidget {
  final dynamic colors;
  final List<HubEvent> events;

  const _EventsTab({required this.colors, required this.events});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _SectionHeader(title: 'الفعاليات القادمة', colors: colors),
              SizedBox(height: 12.h),
            ]),
          ),
        ),
        if (events.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'لا توجد فعاليات متاحة حالياً',
                style: TextStyle(color: colors.textSecondary, fontSize: 14.sp),
              ),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _EventCard(
                    event: events[index],
                    colors: colors,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HubEventScreen(event: events[index]),
                      ),
                    ),
                  ),
                );
              }, childCount: events.length),
            ),
          ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: 80.h),
          sliver: SliverToBoxAdapter(child: SizedBox.shrink()),
        ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  final HubEvent event;
  final dynamic colors;
  final VoidCallback onTap;

  const _EventCard({
    required this.event,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colors.border.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (event.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: Image.network(
                  event.imageUrl,
                  height: 150.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150.h,
                    color: colors.surface,
                    child: Center(
                      child: Icon(
                        Icons.event,
                        size: 40.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14.sp,
                        color: colors.primary,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          '${event.date} ${event.time}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14.sp,
                        color: colors.primary,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _Badge(
                    label: event.status.isNotEmpty ? event.status : 'متاح',
                    colors: colors,
                    isSecondary: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainingCard extends StatelessWidget {
  final HubTraining training;
  final dynamic colors;
  final VoidCallback onTap;

  const _TrainingCard({
    required this.training,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240.w,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: colors.border.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  color: colors.primary,
                ),
                child: Center(
                  child: Icon(
                    Icons.school_outlined,
                    size: 44.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      training.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      training.instructor.isNotEmpty
                          ? 'بواسطة ${training.instructor}'
                          : 'التفاصيل متاحة',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      training.location,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'السعر: ${training.price.isNotEmpty ? training.price : 'مجاني'}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'التفاصيل',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final HubJob job;
  final dynamic colors;

  const _JobCard({required this.job, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.border.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.work_outline,
                  color: colors.primary,
                  size: 20.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  job.status.isNotEmpty ? job.status : 'متاح',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            job.title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '${job.company} • ${job.location}',
            style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                size: 14.sp,
                color: colors.textSecondary,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  job.salary.isNotEmpty ? job.salary : 'لم يُحدد',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final dynamic colors;

  const _SectionHeader({required this.title, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final dynamic colors;
  final bool isSecondary;

  const _Badge({
    required this.label,
    required this.colors,
    required this.isSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isSecondary ? const Color(0xFFD6D3FF) : const Color(0xFFDEF0FF),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          color: isSecondary ? const Color(0xFF5B5A7F) : colors.primary,
        ),
      ),
    );
  }
}
