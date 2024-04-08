// lib/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:raymay/api/token_manager.dart';

Dio createDio() {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://qos.reimei-fujii.developers.engineerforce.io/api/v1',
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
    ),
  );

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final accessToken = await TokenManager.getAccessToken();
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
      // Handle request
      return handler.next(options);
    },
    onResponse: (response, handler) {
      // Handle successful responses
      return handler.next(response);
    },
    onError: (DioError e, handler) async {
      // handle error response
      if (e.response?.statusCode == 403) {
        try {
          // Refresh token and retry the original request
          final newResponse = await refreshToken(dio);
          return handler.resolve(newResponse);
        } on DioError catch (refreshError) {
          // Handle refresh error
          return handler.reject(refreshError);
        }
      }
      return handler.reject(e);
    },
  ));

  return dio;
}

Future<Response<dynamic>> refreshToken(dio) async {
  try {
    final refreshToken = await TokenManager.getRefreshToken();
    if (refreshToken == null) {
      throw Error();
      //  throw DioError(
      // response: Response(data: 'Refresh token not available', requestOptions: ''),
      // );
    }
    final response = await dio.post(
      '/token/refresh/', // Assuming this is your refresh token endpoint
      data: {'refresh': refreshToken},
    );

    // Extract the new access token from the response
    final newAccessToken = response.data['access'];
    final newRefreshToken = response.data['refresh'];

    // Save the new access token
    await TokenManager.saveTokens(newAccessToken, newRefreshToken);

    // Return the refreshed response
    return response;
  } catch (error) {
    rethrow;
  }
}
