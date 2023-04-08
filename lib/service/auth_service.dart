import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/main.dart';
import 'package:maxsociety/model/user_profile_model.dart';
import 'package:maxsociety/service/api_service.dart';
import 'package:maxsociety/service/snakbar_service.dart';
import 'package:maxsociety/util/constants.dart';
import 'package:maxsociety/util/preference_key.dart';
import 'package:string_validator/string_validator.dart';

import '../util/messages.dart';

enum AuthStatus {
  notAuthenticated,
  authenticating,
  authenticated,
  error,
  forgotPwdMailSent
}

class AuthProvider extends ChangeNotifier {
  User? user;
  AuthStatus? status = AuthStatus.notAuthenticated;
  late FirebaseAuth _auth;

  static AuthProvider instance = AuthProvider();

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _checkCurrentUserIsAuthenticated();
  }

  void _checkCurrentUserIsAuthenticated() async {
    user = _auth.currentUser;
    if (user != null) {
      if (user!.emailVerified) {
      } else {
        logoutUser();
      }
    }
  }

  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      user = null;
      prefs.clear();
      status = AuthStatus.notAuthenticated;
    } catch (e) {
      SnackBarService.instance.showSnackBarError("Error Logging Out");
    }
    notifyListeners();
  }

  Future<void> loginUserWithEmailAndPassword(
      String email, String password) async {
    if (!isEmail(email)) {
      SnackBarService.instance.showSnackBarError('Enter valid email');
      return;
    }
    if (password.isEmpty) {
      SnackBarService.instance.showSnackBarError('Enter password');
      return;
    }
    status = AuthStatus.authenticating;
    notifyListeners();
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;

      if (!user!.emailVerified) {
        SnackBarService.instance.showSnackBarError(onEmailNotVerified);
        status = AuthStatus.error;
        logoutUser();
      } else {
        // TODO : update last login or any api call after auth
        UserProfile userProfile =
            await ApiProvider.instance.getUserById(user!.uid);
        prefs.setString(PreferenceKey.user, userProfile.toJson());

        if (prefs.containsKey(PreferenceKey.fcmToken)) {
          userProfile.fcmToken = prefs.getString(PreferenceKey.fcmToken);
          await ApiProvider.instance.updateUserSilently(userProfile);
        }
        status = AuthStatus.authenticated;
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      SnackBarService.instance.showSnackBarError(e.message!);
      status = AuthStatus.error;
      user = null;
      notifyListeners();
    }
  }

  Future<bool> registerUserWithEmailAndPassword(
      UserProfile newUser, String password) async {
    if (newUser.userName?.isEmpty ?? true) {
      SnackBarService.instance.showSnackBarError('Enter Full name');
      return false;
    }
    if (!isEmail(newUser.email ?? '')) {
      SnackBarService.instance.showSnackBarError('Enter valid email');
      return false;
    }
    if (password.trim().isEmpty || password.trim().length < 8) {
      SnackBarService.instance
          .showSnackBarError('Password must be 8 character long');
      return false;
    }

    status = AuthStatus.authenticating;
    notifyListeners();
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: newUser.email!.trim(), password: password.trim());
      user = result.user;
      status = AuthStatus.authenticated;
      user!.updateDisplayName(newUser.userName);
      user!.sendEmailVerification();
      //TODO :  API call to create user in database
      newUser.userId = user!.uid;
      await ApiProvider.instance.createUser(newUser);
      SnackBarService.instance.showSnackBarSuccess(onSuccessfullSignupMsg);
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      SnackBarService.instance.showSnackBarError(e.message!);
      status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    if (!isEmail(email)) {
      SnackBarService.instance.showSnackBarError('Enter valid email');
      return false;
    }
    status = AuthStatus.authenticating;
    notifyListeners();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      status = AuthStatus.forgotPwdMailSent;
      notifyListeners();
      SnackBarService.instance
          .showSnackBarSuccess("Please check your mail for reset link");
      return true;
    } on FirebaseAuthException catch (e) {
      SnackBarService.instance.showSnackBarError(e.message!);
      status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    if (newPassword.trim().isEmpty || newPassword.trim().length < 8) {
      SnackBarService.instance
          .showSnackBarError('Password must be 8 character long');
      return false;
    }

    status = AuthStatus.authenticating;
    notifyListeners();
    try {
      bool res = false;
      user = _auth.currentUser;
      await user?.updatePassword(newPassword).then((value) {
        res = true;
        SnackBarService.instance.showSnackBarSuccess('Password changed');
      }).catchError((onError) {
        res = false;
        log(onError.toString());
        SnackBarService.instance
            .showSnackBarError('ERR : ${onError.toString()}');
      });
      status = AuthStatus.authenticated;
      notifyListeners();
      return res;
    } on FirebaseAuthException catch (e) {
      SnackBarService.instance.showSnackBarError(e.message!);
      status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }
}
