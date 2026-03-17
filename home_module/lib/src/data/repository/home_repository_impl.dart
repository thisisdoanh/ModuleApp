import 'package:dependency/dependency.dart';

import '../model/user_profile.dart';
import 'home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<UserProfile> getUserProfile(String userId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/api/users/$userId');
      return UserProfile.fromJson(response.data!);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
