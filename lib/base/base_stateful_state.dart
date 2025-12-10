import 'package:flutter/material.dart';

import '../resources/color.dart';
import '../utils/slide_left_route.dart';

abstract class BaseStatefulWidgetState<StateMVC extends StatefulWidget> extends State<StateMVC> {
  late ThemeData baseTheme;
  bool shouldShowProgress = false;
  bool shouldHaveSafeArea = true;
  bool resizeToAvoidBottomInset = true;
  final rootScaffoldKey = GlobalKey<ScaffoldState>();
  late Size screenSize;
  bool isBackgroundImage = false;
  bool extendBodyBehindAppBar = false;
  Color? scaffoldBgColor;
  String? backgroundPNGImage;
  FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  void didChangeDependencies() {
    baseTheme = Theme.of(context);
    screenSize = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  void pushAndClearStack(BuildContext context, {required Widget enterPage, bool shouldUseRootNavigator = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Future.delayed(const Duration(milliseconds: 200)).then((value) =>
        Navigator.of(context, rootNavigator: shouldUseRootNavigator).pushAndRemoveUntil(createRoute(context, enterPage), (route) => false));
  }

  void pushReplacement(BuildContext context, {required Widget enterPage, bool shouldUseRootNavigator = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Future.delayed(const Duration(milliseconds: 200))
        .then((value) => Navigator.of(context, rootNavigator: shouldUseRootNavigator).pushReplacement(createRoute(context, enterPage)));
  }

  void push(BuildContext context, {required Widget enterPage, bool shouldUseRootNavigator = false, Function? callback}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    FocusScope.of(context).requestFocus(FocusNode());
    Future.delayed(const Duration(milliseconds: 200))
        .then((value) => Navigator.of(context, rootNavigator: shouldUseRootNavigator).push(createRoute(context, enterPage)).then((value) {
              callback?.call(value);
            }));
  }

  void clearStackAndPush(BuildContext context, String targetScreenName, {required Widget enterPage, bool shouldUseRootNavigator = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    Navigator.of(context, rootNavigator: shouldUseRootNavigator).popUntil((route) {
      return route.settings.name == targetScreenName;
    });

    Navigator.of(context, rootNavigator: shouldUseRootNavigator).push(createRoute(context, enterPage));
  }

  Future<dynamic> pushForResult(
    BuildContext context, {
    required Widget enterPage,
    bool shouldUseRootNavigator = false,
  }) {
    return Navigator.of(context, rootNavigator: shouldUseRootNavigator).push(
      createRoute(context, enterPage),
    );
  }

  void goBack([val]) {
    Navigator.pop(rootScaffoldKey.currentContext!, val);
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent = buildBody(context);

    return GestureDetector(
      onTap: () => FocusScope.of(rootScaffoldKey.currentContext!).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        key: rootScaffoldKey,
        extendBody: false,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        backgroundColor: scaffoldBgColor ?? colorWhite,
        appBar: buildAppBar(context),
        body: bodyContent,
        bottomNavigationBar: buildBottomNavigationBar(context),
        floatingActionButton: buildFloatingActionButton(context),
        floatingActionButtonLocation: floatingActionButtonLocation ?? FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  @protected
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return null;
  }

  Widget buildBody(BuildContext context) {
    return widget;
  }

  Widget? buildBottomNavigationBar(BuildContext context) {
    return null;
  }

  Widget? buildFloatingActionButton(BuildContext context) {
    return null;
  }
}
