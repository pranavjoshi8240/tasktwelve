import 'package:dio/dio.dart';
import 'package:tasktwelve/repo_api/dio_helper.dart';
import 'package:tasktwelve/repo_api/rest_constants.dart';
import 'package:tasktwelve/resources/strings.dart';
import 'package:tasktwelve/screens/products/models/product_model.dart';

class ProductRepository {
  /// Fetch products with pagination
  Future<ProductListResponse> getProducts({
    int skip = 0,
    int limit = 30,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: RestConstants.products,
        query: {
          'skip': skip,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        return ProductListResponse.fromJson(response.data);
      } else {
        throw Exception('$strFailedToLoadProducts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage = strNetworkError;
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = strConnectionTimeout;
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = strReceiveTimeout;
      } else if (e.type == DioExceptionType.sendTimeout) {
        errorMessage = strSendTimeout;
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = strConnectionError;
      } else if (e.message != null && e.message!.contains('Failed host lookup')) {
        errorMessage = strUnableToConnectToServer;
      } else {
        errorMessage = '$strNetworkError: ${e.message ?? strUnknownError}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('$strErrorFetchingProducts: $e');
    }
  }

  /// Fetch single product by ID
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await DioHelper.getData(
        url: '${RestConstants.productById}$id',
      );

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw Exception('$strFailedToLoadProduct: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage = strNetworkError;
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = strConnectionTimeout;
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = strConnectionError;
      } else if (e.message != null && e.message!.contains('Failed host lookup')) {
        errorMessage = strUnableToConnectToServer;
      } else {
        errorMessage = '$strNetworkError: ${e.message ?? strUnknownError}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('$strErrorFetchingProduct: $e');
    }
  }

  /// Delete product (simulated - dummyjson doesn't actually delete)
  Future<bool> deleteProduct(int id) async {
    try {
      final response = await DioHelper.deleteData(
        url: '${RestConstants.productById}$id',
      );

      // DummyJSON returns 200 even for non-existent products
      // In a real app, you'd check the response
      return response.statusCode == 200;
    } on DioException catch (e) {
      String errorMessage = strNetworkError;
      if (e.type == DioExceptionType.connectionError) {
        errorMessage = strConnectionError;
      } else if (e.message != null && e.message!.contains('Failed host lookup')) {
        errorMessage = strUnableToConnectToServer;
      } else {
        errorMessage = '$strNetworkError: ${e.message ?? strUnknownError}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('$strErrorDeletingProduct: $e');
    }
  }
}

