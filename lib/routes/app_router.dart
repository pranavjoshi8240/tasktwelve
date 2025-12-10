import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasktwelve/resources/strings.dart';
import 'package:tasktwelve/screens/products/models/product_model.dart';
import 'package:tasktwelve/screens/products/product_detail_screen.dart';
import 'package:tasktwelve/screens/products/product_list_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductListScreen(),
      ),
      GoRoute(
        path: '/product-detail',
        builder: (context, state) {
          final product = state.extra as ProductModel?;
          if (product == null) {
            // If no product passed, navigate back
            return const ProductListScreen();
          }
          return ProductDetailScreen(product: product);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('$strError: ${state.error}'),
      ),
    ),
  );
}


