import 'package:get/get.dart';
import 'package:pi_app_admin/userPreferences/user_preferences.dart';

import '../users/model/user.dart';

class CurrentUser extends GetxController {
  Rx<User> _currentUser = User(/* 0, */'','','','','','','','','').obs;
  
  User get user => _currentUser.value;
  getUserInfo() async {
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }
  
}