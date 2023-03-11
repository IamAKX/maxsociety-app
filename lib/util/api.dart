class Api {
  static const String baseUrl = 'http://65.0.85.7:80/';

  // users
  static const String getAllUsers = '${baseUrl}maxsociety/users/';
  static const String getUserByUserId = '${baseUrl}maxsociety/users/';
  static const String createUser = '${baseUrl}maxsociety/users/';
  static const String updateUser = '${baseUrl}maxsociety/users/user';

  // circular
  static const String getCirculars = '${baseUrl}maxsociety/circulars';
  static const String getCircularsBySocietyCode =
      '${baseUrl}maxsociety/circulars/society/';
  static const String createCirculars = '${baseUrl}maxsociety/circulars';
  static const String updateCirculars = '${baseUrl}maxsociety/circulars';

  // flat
  static const String getFlats = '${baseUrl}maxsociety/flats';
  static const String getMembersByFlatNo =
      '${baseUrl}maxsociety/flats/members/';
  static const String getFlatByFlatNo = '${baseUrl}maxsociety/flats/';
  static const String createFlat = '${baseUrl}maxsociety/flats';
  static const String updateFlat = '${baseUrl}maxsociety/flats';
}
