import '../model/user_role.dart';

List<String> serviceRequestCategories = [
  'Cleaning',
  'Complaint',
  'Electrical',
  'Plumbing',
  'Kitchen',
  'General'
];

List<String> vehicleTypeList = [
  '2-wheeler',
  '4-wheeler',
  'Other',
];

List<String> genderList = [
  'MALE',
  'FEMALE',
];

List<String> relationshipList = [
  'FATHER',
  'MOTHER',
  'DAUGHTER',
  'SON',
  'BROTHER',
  'SISTER',
  'TENANT',
  'OTHER'
];

List<String> committeeMemberDesignationList = [
  'President',
  'Secretary',
  'Finance',
  'Members'
];

List<String> committeeMemberCategoryList = ['General', 'ST'];

List<String> flatFormat1 = [
  'A-101',
  'A-102',
  'A-103',
  'A-201',
  'A-202',
  'A-203',
  'A-301',
  'A-302',
  'A-303',
];

List<String> flatFormat2 = [
  'A-1001',
  'A-1002',
  'A-1003',
  'A-2001',
  'A-2002',
  'A-2003',
  'A-3001',
  'A-3002',
  'A-3003',
];

List<UserRole> adminRole = [
  UserRole(name: 'AUDITOR', id: 1),
  UserRole(name: 'ADMIN', id: 2),
  UserRole(name: 'MEMBER', id: 3),
];
List<UserRole> auditorRole = [
  UserRole(name: 'AUDITOR', id: 1),
  UserRole(name: 'MEMBER', id: 3),
];
List<UserRole> memberRole = [
  UserRole(name: 'MEMBER', id: 3),
];

String userDefaultRelationship = 'SELF';
