import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';

class StorageService {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserProfileAdapter());

    await Hive.openBox<UserProfile>('profiles');
  }
}
