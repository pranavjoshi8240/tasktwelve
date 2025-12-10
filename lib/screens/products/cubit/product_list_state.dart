part of 'product_list_cubit.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  List<ProductModel> get products => [];

  @override
  List<Object?> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {
  final List<ProductModel> _products;

  const ProductListLoading({List<ProductModel> products = const []}) : _products = products;

  @override
  List<ProductModel> get products => _products;

  @override
  List<Object?> get props => [_products];
}

class ProductListLoaded extends ProductListState {
  final List<ProductModel> products;
  final bool hasMore;

  const ProductListLoaded({
    required this.products,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [products, hasMore];
}

class ProductListError extends ProductListState {
  final String message;
  final List<ProductModel> _products;

  const ProductListError(this.message, {List<ProductModel> products = const []}) : _products = products;

  @override
  List<ProductModel> get products => _products;

  @override
  List<Object?> get props => [message, _products];
}

