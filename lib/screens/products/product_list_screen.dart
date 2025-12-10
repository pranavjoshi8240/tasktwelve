import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:tasktwelve/base/base_stateful_state.dart';
import 'package:tasktwelve/resources/color.dart';
import 'package:tasktwelve/resources/strings.dart';
import 'package:tasktwelve/common_widgets/common_widgets.dart';
import 'package:tasktwelve/screens/products/cubit/product_list_cubit.dart';
import 'package:tasktwelve/screens/products/models/product_model.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends BaseStatefulWidgetState<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get shouldHaveSafeArea => true;

  @override
  Color? get scaffoldBgColor => colorWhite;

  @override
  void initState() {
    super.initState();
    context.read<ProductListCubit>().fetchProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<ProductListCubit>().loadMoreProducts();
    }
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(strProducts),
      backgroundColor: colorPrimary,
      foregroundColor: colorPrimary2,
      elevation: 0,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocConsumer<ProductListCubit, ProductListState>(
      listener: (context, state) {
        if (state is ProductListError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProductListLoading && state.products.isEmpty) {
          return shimmerProductList(count: 5);
        }

        if (state is ProductListError && state.products.isEmpty) {
          return errorWidget(
            message: state.message,
            onRetry: () {
              context.read<ProductListCubit>().fetchProducts();
            },
          );
        }

        final products = (state is ProductListLoaded)
            ? state.products
            : (state is ProductListError)
                ? state.products
                : (state is ProductListLoading)
                    ? state.products
                    : <ProductModel>[];

        if (products.isEmpty) {
          return emptyDataScreen(
            context: context,
            title: strNoProductsFound,
            message: strTryRefreshingToLoadProducts,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await context.read<ProductListCubit>().refreshProducts();
          },
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(16.w),
            itemCount: products.length + (state is ProductListLoaded && state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= products.length) {
                return paginationLoader();
              }

              final product = products[index];
              return _buildProductTile(product);
            },
          ),
        );
      },
    );
  }

  Widget _buildProductTile(ProductModel product) {
    return _ProductTileWidget(product: product);
  }
}

class _ProductTileWidget extends StatefulWidget {
  final ProductModel product;

  const _ProductTileWidget({required this.product});

  @override
  State<_ProductTileWidget> createState() => _ProductTileWidgetState();
}

class _ProductTileWidgetState extends State<_ProductTileWidget> {
  int _currentImageIndex = 0;
  late final CarouselSliderController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure we have at least 3 images for the slider
    final images = widget.product.images.length >= 3
        ? widget.product.images.take(3).toList()
        : widget.product.images.isNotEmpty
            ? widget.product.images
            : [widget.product.thumbnail];

    return Dismissible(
      key: Key('product_${widget.product.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.red.shade50,
              Colors.red.shade100,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.red.shade200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: colorWhite,
                    size: 24.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 24.w),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.red.shade200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.arrow_back_ios,
              color: Colors.red.shade400,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Swipe to delete',
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        context.read<ProductListCubit>().deleteProduct(widget.product.id);
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('${widget.product.title} $strProductDeleted'),
            duration: const Duration(seconds: 2),
            backgroundColor: colorPrimary2,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            action: SnackBarAction(
              label: strUndo,
              textColor: colorPrimary,
              onPressed: () {
                context.read<ProductListCubit>().refreshProducts();
              },
            ),
          ),
        );
        // Ensure snackbar dismisses after 2 seconds even with action button
        Timer(const Duration(seconds: 2), () {
          if (scaffoldMessenger.mounted) {
            scaffoldMessenger.hideCurrentSnackBar();
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            context.push('/product-detail', extra: widget.product);
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Slider with Indicator
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: CarouselSlider.builder(
                      carouselController: _carouselController,
                      itemCount: images.length,
                      options: CarouselOptions(
                        height: 220.h,
                        viewportFraction: 1.0,
                        autoPlay: images.length > 1,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: images.length > 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade200,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: images[index],
                                width: double.infinity,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey.shade100,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorPrimary,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey.shade100,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey.shade400,
                                    size: 48.sp,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // Image indicator with animated design (same as detail screen)
                  if (images.length > 1)
                    Positioned(
                      bottom: 12.h,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => GestureDetector(
                            onTap: () {
                              _carouselController.animateToPage(index);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: _currentImageIndex == index ? 24.w : 8.w,
                              height: 8.h,
                              margin: EdgeInsets.symmetric(horizontal: 3.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _currentImageIndex == index
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade400,
                                border: Border.all(
                                  color: Colors.grey.shade500,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.product.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: colorPrimary2,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12.h),
                    // Price Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '\$${widget.product.discountedPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: colorPrimary2,
                                ),
                              ),
                              if (widget.product.discountPercentage > 0) ...[
                                SizedBox(width: 8.w),
                                Text(
                                  '\$${widget.product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (widget.product.discountPercentage > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorFF6264,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '-${widget.product.discountPercentage.toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: colorWhite,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
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
      ),
    );
  }
}
