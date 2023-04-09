import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maxsociety/main.dart';
import 'package:maxsociety/model/user_profile_model.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/preference_key.dart';

String getFileName(File? file) {
  return file?.path.split('/').last ?? '';
}

String getFileExtension(File? file) {
  return getFileName(file).split('.').last;
}

getCircularStatusColor(String status) {
  switch (status) {
    case 'OPEN':
      return Colors.green;
    case 'DRAFT':
      return Colors.blue;
    case 'INPROGRESS':
      return Colors.orange;
    case 'PENDING':
      return Colors.amber;
    case 'PUBLISHED':
      return Colors.brown;
    case 'CLOSED':
      return Colors.red;
    default:
      return textColorDark;
  }
}

bool isAdminUser() {
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  if (userProfile.roles!.any(
      (element) => (element.name == 'MEMBER') || (element.name == 'GUARD'))) {
    return false;
  }
  return true;
}

bool isGuardUser() {
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  if (userProfile.roles!.any((element) => (element.name == 'GUARD'))) {
    return true;
  }
  return false;
}
