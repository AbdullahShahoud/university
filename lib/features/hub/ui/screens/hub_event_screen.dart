import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/background.dart';
import '../../data/models/hub_models.dart';

class HubEventScreen extends StatelessWidget {
  final HubEvent event;

  const HubEventScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Background(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: colors.background,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: colors.primary,
                  size: 18.sp,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                event.title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Divider(
                  height: 1,
                  color: colors.border.withValues(alpha: 0.25),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if (event.imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.network(
                        event.imageUrl,
                        height: 200.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200.h,
                          color: colors.surface,
                          child: Center(
                            child: Icon(
                              Icons.event,
                              size: 44.sp,
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (event.imageUrl.isNotEmpty) SizedBox(height: 20.h),
                  Text(
                    'عن الفعالية',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    event.description.isNotEmpty
                        ? event.description
                        : 'لا توجد تفاصيل إضافية حالياً.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: colors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _DetailRow(title: 'التاريخ', value: event.date),
                  SizedBox(height: 12.h),
                  _DetailRow(title: 'الوقت', value: event.time),
                  SizedBox(height: 12.h),
                  _DetailRow(title: 'الموقع', value: event.location),
                  SizedBox(height: 12.h),
                  _DetailRow(
                    title: 'نوع الفعالية',
                    value: event.type.isNotEmpty ? event.type : 'غير محدد',
                  ),
                  SizedBox(height: 12.h),
                  _DetailRow(
                    title: 'حالة الحجز',
                    value: event.status.isNotEmpty ? event.status : 'متاح',
                  ),
                  SizedBox(height: 12.h),
                  _DetailRow(
                    title: 'السعر',
                    value: event.price.isNotEmpty ? event.price : 'مجاني',
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'سجل في الفعالية',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const _DetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(fontSize: 13.sp, color: colors.textSecondary),
          ),
        ),
      ],
    );
  }
}
