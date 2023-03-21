// ignore_for_file: constant_identifier_names

enum CircularType {
  CIRCULAR,
  SERVICE_REQUEST,
  COMPLAINT,
  MOM,
  GOVT_CIRCULAR,
  SOCIETY_RULE
}

enum CircularStatus { OPEN, DRAFT, INPROGRESS, PENDING, PUBLISHED, CLOSED }

enum StorageFolders {
  events,
  mom,
  govtCircular,
  profileImage,
  societyImage,
  galleryImage,
  galleryVideo,
  vehicle,
  societyBanner,
  thumbnail,
  serviceRequest,
  rule
}

enum GalleryItemType { IMAGE, VIDEO }

enum FlatType { RESIDENTIAL, COMMERCIAL }
