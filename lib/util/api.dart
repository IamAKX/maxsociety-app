class Api {
  static const String baseUrl = 'http://13.126.46.177:80/';

  // users
  static const String getAllUsers = '${baseUrl}maxsociety/users/';
  static const String getUserByUserId = '${baseUrl}maxsociety/users/';
  static const String createUser = '${baseUrl}maxsociety/users/';
  static const String updateUser = '${baseUrl}maxsociety/users/';
  static const String getUserByRole =
      '${baseUrl}maxsociety/users/?relation=SELF&role=';

  // circular
  static const String getCirculars = '${baseUrl}maxsociety/circulars';
  static const String getCircularsBySocietyCode =
      '${baseUrl}maxsociety/circulars/society/';
  static const String createCirculars = '${baseUrl}maxsociety/circulars';
  static const String updateCirculars = '${baseUrl}maxsociety/circulars/';
  static const String getCircularsByCircularType =
      '${baseUrl}maxsociety/circulars/type/';
  static const String getCircularsByFilter = '${baseUrl}maxsociety/circulars/';
  static const String getCircularById = '${baseUrl}maxsociety/circulars/';

  // flat
  static const String getFlats = '${baseUrl}maxsociety/flats';
  static const String getMembersByFlatNo =
      '${baseUrl}maxsociety/flats/members/';
  static const String getFlatByFlatNo = '${baseUrl}maxsociety/flats/';
  static const String createFlat = '${baseUrl}maxsociety/flats';
  static const String updateFlat = '${baseUrl}maxsociety/flats/';
  static const String deleteFlat = '${baseUrl}maxsociety/flats/';
  static const String createFlatInBulk = '${baseUrl}maxsociety/flats/list';

  // vehicle
  static const String getVehicles = '${baseUrl}maxsociety/vehicles';
  static const String getVehicleByVehicleNo = '${baseUrl}maxsociety/vehicles/';
  static const String getVehiclesByFlatNo =
      '${baseUrl}maxsociety/vehicles/flat/';
  static const String createVehicles = '${baseUrl}maxsociety/vehicles';
  static const String updateVehicles = '${baseUrl}maxsociety/vehicles/';

  // society
  static const String getSociety = '${baseUrl}maxsociety/society/1';
  static const String updateSociety = '${baseUrl}maxsociety/society/';

  // gallery
  static const String createGalleryItem = '${baseUrl}maxsociety/galleryItems/';
  static const String getGalleryItems = '${baseUrl}maxsociety/galleryItems/';
  static const String deleteGalleryItem = '${baseUrl}maxsociety/galleryItems/';

  // emergency contact
  static const String createEmergencyContacts =
      '${baseUrl}maxsociety/emergencyContacts/';
  static const String getEmergencyContacts =
      '${baseUrl}maxsociety/emergencyContacts';
  static const String deleteEmergencyContacts =
      '${baseUrl}maxsociety/emergencyContacts/';

// notification
  static const String getNotifications =
      '${baseUrl}maxsociety/notifications/getNotifications';
  static const String sendNotification =
      '${baseUrl}maxsociety/notifications/sendNotification';

// deregister
  static const String createDeRegistrationRequests =
      '${baseUrl}maxsociety/dereg';
  static const String updateDeRegistrationRequests =
      '${baseUrl}maxsociety/dereg/';
  static const String getDeRegistrationRequest =
      '${baseUrl}maxsociety/dereg/';
  static const String getAllDeRegistrationRequests =
      '${baseUrl}maxsociety/dereg';
}
