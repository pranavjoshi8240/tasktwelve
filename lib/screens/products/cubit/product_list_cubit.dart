import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasktwelve/repository/product_repository.dart';
import 'package:tasktwelve/resources/strings.dart';
import 'package:tasktwelve/screens/products/models/product_model.dart';
part 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final ProductRepository _repository;

  ProductListCubit(this._repository) : super(ProductListInitial());

  List<ProductModel> _allProducts = [];
  int _currentSkip = 0;
  static const int _limit = 30;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  /// Fetch initial products
  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentSkip = 0;
      _allProducts.clear();
      _hasMore = true;
      emit(ProductListLoading());
    } else if (state is ProductListLoading) {
      // Already loading, don't emit again
    } else {
      emit(ProductListLoading());
    }

    try {
      final response = await _repository.getProducts(
        skip: _currentSkip,
        limit: _limit,
      );

      if (isRefresh) {
        _allProducts = response.products;
      } else {
        _allProducts.addAll(response.products);
      }

      _currentSkip = _allProducts.length;
      _hasMore = _allProducts.length < response.total;

      emit(ProductListLoaded(
        products: List.from(_allProducts),
        hasMore: _hasMore,
      ));
    } catch (e) {
      emit(ProductListError(e.toString(), products: List.from(_allProducts)));
    }
  }

  /// Load more products (pagination)
  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;

    try {
      final response = await _repository.getProducts(
        skip: _currentSkip,
        limit: _limit,
      );

      if (response.products.isNotEmpty) {
        _allProducts.addAll(response.products);
        _currentSkip = _allProducts.length;
        _hasMore = _allProducts.length < response.total;

        emit(ProductListLoaded(
          products: List.from(_allProducts),
          hasMore: _hasMore,
        ));
      } else {
        _hasMore = false;
        emit(ProductListLoaded(
          products: List.from(_allProducts),
          hasMore: false,
        ));
      }
    } catch (e) {
      emit(ProductListError(e.toString(), products: List.from(_allProducts)));
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Delete a product
  Future<void> deleteProduct(int productId) async {
    try {
      // Optimistically remove from list
      final productIndex = _allProducts.indexWhere((p) => p.id == productId);
      if (productIndex != -1) {
        _allProducts.removeAt(productIndex);
        _currentSkip = _allProducts.length;

        emit(ProductListLoaded(
          products: List.from(_allProducts),
          hasMore: _hasMore,
        ));

        // Call API to delete (even though dummyjson doesn't actually delete)
        await _repository.deleteProduct(productId);
      }
    } catch (e) {
      // If deletion fails, reload products
      fetchProducts();
      emit(ProductListError('$strFailedToDeleteProduct: ${e.toString()}', products: List.from(_allProducts)));
    }
  }

  /// Pull to refresh
  Future<void> refreshProducts() async {
    await fetchProducts(isRefresh: true);
  }
}

