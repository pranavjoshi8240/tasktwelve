import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasktwelve/repo_api/dio_helper.dart';
import 'package:tasktwelve/repository/product_repository.dart';
import 'package:tasktwelve/routes/app_router.dart';
import 'package:tasktwelve/screens/products/cubit/product_list_cubit.dart';
import 'package:tasktwelve/utils/shared_preference_util.dart';
import 'package:tasktwelve/resources/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences
  await SharedPreferenceUtil.getInstance();
  
  // Initialize Dio
  await DioHelper.init();
  
  // Initialize ScreenUtil
  await ScreenUtil.ensureScreenSize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ProductListCubit(ProductRepository()),
            ),
          ],
          child: MaterialApp.router(
            title: 'Task Twelve',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: customSwatch,
              primaryColor: colorPrimary,
              colorScheme: ColorScheme.fromSeed(
                seedColor: colorPrimary,
                primary: colorPrimary,
              ),
              scaffoldBackgroundColor: colorWhite,
              appBarTheme: AppBarTheme(
                backgroundColor: colorPrimary,
                foregroundColor: colorPrimary2,
                elevation: 0,
              ),
              useMaterial3: true,
            ),
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
