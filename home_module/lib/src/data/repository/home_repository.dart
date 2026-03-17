import '../model/user_profile.dart';

abstract class HomeRepository {
  Future<UserProfile> getUserProfile(String userId);
}
