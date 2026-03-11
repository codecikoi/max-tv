import 'package:dio/dio.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import '../constants/app_constants.dart';
import 'token_storage.dart';

class DioClient {
  late final Dio dio;
  final TokenStorage _tokenStorage;

  DioClient(this._tokenStorage, Talker talker) {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(_AuthInterceptor(_tokenStorage));

    dio.interceptors.add(_ErrorInterceptor());

    dio.interceptors.add(TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestData: true,
        printResponseData: true,
      ),
    ));
  }
}

class _AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  /// Paths that do not require a Bearer token.
  static const _publicPaths = [
    '/login',
    '/register/email',
    '/register/confirm',
    '/register/complete',
    '/register/resend',
  ];

  _AuthInterceptor(this._tokenStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isPublic = _publicPaths.any((p) => options.path.endsWith(p));
    if (!isPublic) {
      final token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    String message;

    final data = err.response?.data;
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      message = data['message'] as String;
    } else {
      switch (statusCode) {
        case 400:
          message = 'Неверный запрос.';
          break;
        case 401:
          message = 'Неверный логин или пароль.';
          break;
        case 403:
          message = 'Доступ запрещён.';
          break;
        case 404:
          message = 'Ресурс не найден.';
          break;
        case 422:
          message = 'Ошибка валидации.';
          break;
        case 500:
          message = 'Ошибка сервера. Попробуйте позже.';
          break;
        default:
          message = err.message ?? 'Что-то пошло не так.';
      }
    }

    handler.next(DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: message,
      message: message,
    ));
  }
}
