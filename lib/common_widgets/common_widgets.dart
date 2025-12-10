import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../resources/color.dart';
import '../resources/strings.dart';

/// Height box helper widget
Widget heightBox(double height) {
  return SizedBox(height: height);
}

/// Width box helper widget
Widget widthBox(double width) {
  return SizedBox(width: width);
}

/// Common loader widget
Widget commonLoader({double? size, Color? color}) {
  return Center(
    child: SizedBox(
      width: size ?? 48,
      height: size ?? 48,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? colorPrimary),
      ),
    ),
  );
}

/// Pagination loader widget (smaller, for bottom of lists)
Widget paginationLoader({double? size, Color? color}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: size ?? 30,
        height: size ?? 30,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? colorPrimary2),
        ),
      ),
    ),
  );
}

/// Shimmer effect widget for loading placeholders
Widget shimmerLoader({
  double? width,
  double? height,
  double borderRadius = 8,
  Color? baseColor,
  Color? highlightColor,
}) {
  return Shimmer.fromColors(
    baseColor: baseColor ?? Colors.grey[300]!,
    highlightColor: highlightColor ?? Colors.grey[100]!,
    child: Container(
      width: width ?? double.infinity,
      height: height ?? 20,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );
}

/// Shimmer card for product list item
Widget shimmerProductCard() {
  return Card(
    margin: EdgeInsets.only(bottom: 16.h),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image placeholder
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: shimmerLoader(
            width: double.infinity,
            height: 200.h,
            borderRadius: 0,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title placeholder
              shimmerLoader(
                width: double.infinity,
                height: 20.h,
                borderRadius: 4,
              ),
              SizedBox(height: 8.h),
              shimmerLoader(
                width: 150.w,
                height: 20.h,
                borderRadius: 4,
              ),
              SizedBox(height: 12.h),
              // Price placeholder
              shimmerLoader(
                width: 100.w,
                height: 24.h,
                borderRadius: 4,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Shimmer list for product list screen
Widget shimmerProductList({int count = 3}) {
  return ListView.builder(
    padding: EdgeInsets.all(16.w),
    itemCount: count,
    itemBuilder: (context, index) {
      return shimmerProductCard();
    },
  );
}

/// Empty data screen widget
Widget emptyDataScreen({
  required BuildContext context,
  String? title,
  String? message,
  IconData? icon,
  double? iconSize,
  Color? iconColor,
}) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.6,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.inbox_outlined,
            size: iconSize ?? 64.sp,
            color: iconColor ?? Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          if (title != null)
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: colorPrimary2,
              ),
              textAlign: TextAlign.center,
            ),
          if (message != null) ...[
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

/// Error widget with retry button
Widget errorWidget({
  required String message,
  VoidCallback? onRetry,
  IconData? icon,
}) {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.error_outline,
            size: 64.sp,
            color: colorFF6264,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              color: colorPrimary2,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text(strRetry),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorPrimary2,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

/// Custom text widget with common styling
class CustomTextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;

  const CustomTextWidget({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? 14.sp,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? colorPrimary2,
        letterSpacing: letterSpacing,
        height: height,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Loading overlay widget
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      commonLoader(),
                      if (message != null) ...[
                        SizedBox(height: 16.h),
                        Text(
                          message!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: colorPrimary2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Divider with spacing
Widget dividerWithSpacing({
  double? height,
  Color? color,
  double? thickness,
  double? indent,
  double? endIndent,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: height ?? 16.h),
    child: Divider(
      color: color ?? Colors.grey[300],
      thickness: thickness ?? 1,
      indent: indent,
      endIndent: endIndent,
    ),
  );
}

/// Custom button with consistent styling
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 48.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? colorPrimary,
          foregroundColor: textColor ?? colorPrimary2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? colorPrimary2,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20.sp),
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}


