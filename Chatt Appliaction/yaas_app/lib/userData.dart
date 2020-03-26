class UserData{

  static String _userId;
  static String _userName;

  static String get userName => _userName;

  static set userName(String value) {
    _userName = value;
  }

  static String get userId => _userId;

  static set userId(String value) {
    _userId = value;
  }

}