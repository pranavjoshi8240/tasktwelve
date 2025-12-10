import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasktwelve/resources/color.dart';
import 'app_constants.dart';
import 'slide_left_route.dart';

class AppUtils {
  AppUtils._privateConstructor();

  static final AppUtils instance = AppUtils._privateConstructor();


  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }



  void goBack() {
    Navigator.pop(rootNavigatorKey.currentContext!);
  }

  void pushReplacement({required Widget enterPage, bool shouldUseRootNavigator = false}) {
    ScaffoldMessenger.of(rootNavigatorKey.currentContext!).hideCurrentSnackBar();
    Navigator.of(
      rootNavigatorKey.currentContext!,
      rootNavigator: shouldUseRootNavigator,
    ).pushReplacement(SlideLeftRoute(page: enterPage));
  }

  void push({
    required Widget enterPage,
    bool shouldUseRootNavigator = false,
    Function? callback,
    BuildContext? context,
  }) {
    ScaffoldMessenger.of(context ?? rootNavigatorKey.currentContext!).hideCurrentSnackBar();
    FocusScope.of(context ?? rootNavigatorKey.currentContext!).requestFocus(FocusNode());
    Navigator.of(
      context ?? rootNavigatorKey.currentContext!,
      rootNavigator: shouldUseRootNavigator,
    ).push(SlideLeftRoute(page: enterPage)).then((value) {
      callback?.call(value);
    });
  }

  Future<dynamic> pushForResult(
    BuildContext context, {
    required Widget enterPage,
    bool shouldUseRootNavigator = false,
  }) {
    return Navigator.of(
      context,
      rootNavigator: shouldUseRootNavigator,
    ).push(SlideLeftRoute(page: enterPage));
  }

  void pushAndClearStack({required Widget enterPage, bool shouldUseRootNavigator = false}) {
    ScaffoldMessenger.of(rootNavigatorKey.currentContext!).hideCurrentSnackBar();
    Navigator.of(
      rootNavigatorKey.currentContext!,
      rootNavigator: shouldUseRootNavigator,
    ).pushAndRemoveUntil(SlideLeftRoute(page: enterPage), (Route<dynamic> route) => false);
  }

  double randomGen(int min, int max) {
    return double.tryParse('${min + Random().nextInt(max - min)}') ?? 0;
  }


  static String getDeviceTypeID() {
    return Platform.isAndroid ? androidDevice : iosDevice;
  }
}

void showError({String? message, Color? messageColor}) => Fluttertoast.showToast(
  msg: message.toString(),
  toastLength: Toast.LENGTH_LONG,
  // backgroundColor: messageColor ?? colorFF0000,
  backgroundColor: colorFF6264,
  gravity: ToastGravity.TOP,
);

void showErrorBottom({String? message, Color? messageColor}) => Fluttertoast.showToast(
  msg: message.toString(),
  toastLength: Toast.LENGTH_LONG,
  // backgroundColor: messageColor ?? colorFF0000,
  backgroundColor: messageColor,
  gravity: ToastGravity.BOTTOM,
);

void showSuccess({String? message, Color? messageColor}) => Fluttertoast.showToast(
  msg: message.toString(),
  toastLength: Toast.LENGTH_LONG,
  backgroundColor: messageColor ?? Colors.green,
  gravity: ToastGravity.TOP,
);

extension StringCasingExtension on String {
  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}
