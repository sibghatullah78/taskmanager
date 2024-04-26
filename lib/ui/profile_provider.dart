import 'package:flutter/material.dart';

import '../models/userProfile.dart';

class UserProfileProvider extends ChangeNotifier {
  late UserProfile _userProfile;

  UserProfile get userProfile => _userProfile;

  void setUserProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }
}
