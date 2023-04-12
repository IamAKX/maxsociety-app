import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/main.dart';
import 'package:maxsociety/model/circular_model.dart';
import 'package:maxsociety/model/flat_model.dart';
import 'package:maxsociety/model/list/circular_list_model.dart';
import 'package:maxsociety/model/list/emergency_contact_list_model.dart';
import 'package:maxsociety/model/list/flat_list_model.dart';
import 'package:maxsociety/model/list/gallery_list_model.dart';
import 'package:maxsociety/model/list/user_list_model.dart';
import 'package:maxsociety/model/list/visitor_record_list_model.dart';
import 'package:maxsociety/model/society_model.dart';
import 'package:maxsociety/model/user_profile_model.dart';
import 'package:maxsociety/model/vehicle_model.dart';
import 'package:maxsociety/service/snakbar_service.dart';
import 'package:maxsociety/util/api.dart';
import 'package:maxsociety/util/helper_methods.dart';
import 'package:maxsociety/util/preference_key.dart';

import '../model/list/vehicle_list_model.dart';

enum ApiStatus { ideal, loading, success, failed }

class ApiProvider extends ChangeNotifier {
  ApiStatus? status = ApiStatus.ideal;
  late Dio _dio;
  static ApiProvider instance = ApiProvider();

  ApiProvider() {
    _dio = Dio();
  }

  Future<bool> createUser(UserProfile userProfile) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      var map = userProfile.toMap();
      if (userProfile.flats != null) {
        map['flats'] = {'flatNo': userProfile.flats?.flatNo ?? ''};
      }
      Response response = await _dio.post(
        Api.createUser,
        data: json.encode(map),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        return true;
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<bool> updateUser(UserProfile userProfile) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      var map = userProfile.toMap();
      if (userProfile.flats != null) {
        map['flats'] = {'flatNo': userProfile.flats?.flatNo};
      }
      var reqBody = json.encode(map);
      log(reqBody);
      Response response = await _dio.put(
        Api.updateUser,
        data: reqBody,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();

        SnackBarService.instance.showSnackBarSuccess('Profile updated');

        return true;
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<bool> updateUserSilently(UserProfile userProfile) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      var map = userProfile.toMap();
      if (userProfile.flats != null) {
        map['flats'] = {'flatNo': userProfile.flats?.flatNo};
      }
      var reqBody = json.encode(map);
      log(reqBody);
      Response response = await _dio.put(
        Api.updateUser,
        data: reqBody,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      log(json.encode(response.data));
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        UserProfile user = UserProfile.fromMap(response.data['data']);
        log('saving : ${user.toJson()}');
        prefs.setString(PreferenceKey.user, user.toJson());
        return true;
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      log('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      log(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<UserProfile> getUserById(String userId) async {
    status = ApiStatus.loading;
    notifyListeners();
    late UserProfile userProfile;
    try {
      Response response = await _dio.get(
        '${Api.getUserByUserId}$userId',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        userProfile = UserProfile.fromMap(response.data['data']);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      // SnackBarService.instance
      //     .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      // SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return userProfile;
  }

  Future<bool> createCircular(var circularReqBody) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      log('request body : $circularReqBody');
      Response response = await _dio.post(
        Api.createCirculars,
        data: circularReqBody,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        SnackBarService.instance.showSnackBarSuccess(response.data['message']);
        return true;
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<FlatModel> getFlatByFlatNo(String flatNo) async {
    status = ApiStatus.loading;
    notifyListeners();
    late FlatModel flatModel;
    try {
      Response response = await _dio.get(
        '${Api.getFlatByFlatNo}$flatNo',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        flatModel = FlatModel.fromMap(response.data['data']);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      log(e.toString());
    }
    return flatModel;
  }

  Future<bool> addVehicle(VehicleModel vehicle) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      var map = vehicle.toMap();
      map['flats'] = {'flatNo': vehicle.flats};
      Response response = await _dio.post(
        Api.createVehicles,
        data: json.encode(map),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        SnackBarService.instance.showSnackBarSuccess(response.data['message']);
        return true;
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<bool> updateVehicle(VehicleModel vehicle) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      var map = vehicle.toMap();
      map['flats'] = {'flatNo': vehicle.flats};
      Response response = await _dio.put(
        Api.updateVehicles,
        data: json.encode(map),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        SnackBarService.instance.showSnackBarSuccess(response.data['message']);
        return true;
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<bool> deleteVehicle(String vehicleNo) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Response response = await _dio.delete(
        '${Api.getVehicleByVehicleNo}$vehicleNo',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 204) {
        status = ApiStatus.success;
        notifyListeners();
        SnackBarService.instance.showSnackBarSuccess('Vehicle is deleted');
        return true;
      }
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<VehicleModel> getVehicleByVehicleNo(String vehicleNumber) async {
    status = ApiStatus.loading;
    notifyListeners();
    late VehicleModel vehicleModel;
    try {
      Response response = await _dio.get(
        '${Api.getVehicleByVehicleNo}$vehicleNumber',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        vehicleModel = VehicleModel.fromMap(response.data['data']);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return vehicleModel;
  }

  Future<VehicleModelList> getVehiclesByFlatNo(String flatNo) async {
    status = ApiStatus.loading;
    notifyListeners();
    late VehicleModelList vehicleList;
    try {
      Response response = await _dio.get(
        '${Api.getVehiclesByFlatNo}$flatNo',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        vehicleList = VehicleModelList.fromMap(response.data);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return vehicleList;
  }

  Future<UserListModel> getMembersByFlatNo(String flatNo) async {
    status = ApiStatus.loading;
    notifyListeners();
    late UserListModel userList;
    try {
      Response response = await _dio.get(
        '${Api.getMembersByFlatNo}$flatNo',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        userList = UserListModel.fromMap(response.data);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return userList;
  }

  Future<bool> deleteUser(String userId) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Response response = await _dio.delete(
        '${Api.updateUser}$userId',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 204) {
        status = ApiStatus.success;
        notifyListeners();
        SnackBarService.instance.showSnackBarSuccess('User is deleted');
        return true;
      }
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<SocietyModel> getSociety() async {
    status = ApiStatus.loading;
    notifyListeners();
    late SocietyModel societyModel;
    try {
      Response response = await _dio.get(
        Api.getSociety,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        societyModel = SocietyModel.fromMap(response.data['data']);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return societyModel;
  }

  Future<bool> updateSociety(SocietyModel society) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Response response = await _dio.put(
        Api.updateSociety,
        data: society.toJson(),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        SnackBarService.instance.showSnackBarSuccess(response.data['message']);
        return true;
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<CircularListModel> getCircularsByCircularType(
      String circularType) async {
    status = ApiStatus.loading;
    notifyListeners();
    CircularListModel circularList = CircularListModel(data: []);
    try {
      Response response = await _dio.get(
        '${Api.getCircularsByCircularType}$circularType',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        circularList = CircularListModel.fromMap(response.data);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('ERR : No $circularType found');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return circularList;
  }

  Future<CircularListModel> getCirculars() async {
    status = ApiStatus.loading;
    notifyListeners();
    CircularListModel circularList = CircularListModel(data: []);
    try {
      Response response = await _dio.get(
        Api.getCirculars,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        circularList = CircularListModel.fromMap(response.data);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance.showSnackBarError('ERR : No circular found');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return circularList;
  }

  Future<CircularModel> getCircularById(String circularId) async {
    status = ApiStatus.loading;
    notifyListeners();
    late CircularModel circular;
    log('${Api.getCircularById}$circularId');
    try {
      Response response = await _dio.get(
        '${Api.getCircularById}$circularId',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        circular = CircularModel.fromMap(response.data['data']);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return circular;
  }

  Future<UserListModel> getUsersByRole(String role) async {
    status = ApiStatus.loading;
    notifyListeners();
    late UserListModel userList;
    try {
      Response response = await _dio.get(
        '${Api.getUserByRole}$role',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        userList = UserListModel.fromMap(response.data);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return userList;
  }

  Future<FlatListModel> getFlatList() async {
    status = ApiStatus.loading;
    notifyListeners();
    late FlatListModel flatList;
    try {
      Response response = await _dio.get(
        Api.getFlats,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        flatList = FlatListModel.fromMap(response.data);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return flatList;
  }

  Future<bool> createFlatInBulk(List<FlatModel> flatList) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      var reqBody = [];
      for (FlatModel flat in flatList) {
        var map = flat.toMap();
        map['society'] = {'societyCode': 1};
        map.remove('vehicles');
        reqBody.add(map);
      }
      log('length = ${reqBody.length}');
      log(json.encode(reqBody));
      Response response = await _dio.post(
        Api.createFlatInBulk,
        data: json.encode(reqBody),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarSuccess('${flatList.length} flats created');
        return true;
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<bool> deleteFlat(String flatNo) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Response response = await _dio.delete(
        '${Api.deleteFlat}$flatNo',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 204) {
        status = ApiStatus.success;
        notifyListeners();
        SnackBarService.instance.showSnackBarSuccess('Flat is deleted');
        return true;
      }
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<bool> updateFlat(FlatModel flat) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      var map = flat.toMap();
      map['society'] = {'societyCode': 1};
      map.remove('vehicles');

      var reqBody = json.encode(map);
      Response response = await _dio.put(
        Api.updateFlat,
        data: reqBody,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        SnackBarService.instance.showSnackBarSuccess('Flat updated');
        return true;
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<bool> createGalleryItem(var reqBody) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Response response = await _dio.post(
        Api.createGalleryItem,
        data: json.encode(reqBody),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        SnackBarService.instance.showSnackBarSuccess(response.data['message']);
        return true;
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<GalleryListModel> getGalleryItems() async {
    status = ApiStatus.loading;
    notifyListeners();
    late GalleryListModel galleryList;
    try {
      Response response = await _dio.get(
        Api.getGalleryItems,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        galleryList = GalleryListModel.fromMap(response.data);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return galleryList;
  }

  Future<bool> deleteGalleryItem(int id) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Response response = await _dio.delete(
        '${Api.deleteGalleryItem}$id',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 204) {
        status = ApiStatus.success;
        notifyListeners();
        SnackBarService.instance.showSnackBarSuccess('Media is deleted');
        return true;
      }
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<bool> createEmergencyContact(
      String category, List<String> phoneNumbers) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      var map = {"category": category, "phoneNumbers": phoneNumbers};
      Response response = await _dio.post(
        Api.createEmergencyContacts,
        data: json.encode(map),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        return true;
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<EmergencyContactListModel> getEmergencyContacts() async {
    status = ApiStatus.loading;
    notifyListeners();
    late EmergencyContactListModel emergencyContacts;
    try {
      Response response = await _dio.get(
        Api.getEmergencyContacts,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        emergencyContacts = EmergencyContactListModel.fromMap(response.data);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return emergencyContacts;
  }

  Future<bool> deleteEmergencyContact(int id, String phoneNo) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Response response = await _dio.delete(
        '${Api.deleteEmergencyContacts}$id?phoneNumber=$phoneNo',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 204) {
        status = ApiStatus.success;
        notifyListeners();
        SnackBarService.instance.showSnackBarSuccess('Contact number deleted');
        return true;
      }
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<CircularListModel> getServiceRequestByFilter(
      String circularType) async {
    status = ApiStatus.loading;
    notifyListeners();
    CircularListModel circularList = CircularListModel(data: []);
    try {
      String api = '${Api.getCircularsByFilter}?circularType=$circularType';
      UserProfile userProfile =
          UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
      if (!isAdminUser()) {
        api = '$api&createdBy=${userProfile.userId}';
      }
      Response response = await _dio.get(
        api,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        circularList = CircularListModel.fromMap(response.data);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('ERR : No $circularType found');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return circularList;
  }

  Future<bool> updateCircular(CircularModel circular) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      var map = circular.toMap();
      map['createdBy'] = {"userId": circular.createdBy?.userId};
      map['updatedBy'] = {"userId": circular.createdBy?.userId};
      map.remove('society');
      map.remove('circularImages');
      var reqBody = json.encode(map);
      log(reqBody);
      Response response = await _dio.put(
        Api.updateCirculars,
        data: reqBody,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        SnackBarService.instance.showSnackBarSuccess('Updated successfully');
        return true;
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<UserListModel> getAllUserMember() async {
    status = ApiStatus.loading;
    notifyListeners();
    late UserListModel userList;
    try {
      Response response = await _dio.get(
        Api.getAllUsers,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        userList = UserListModel.fromMap(response.data);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return userList;
  }

  Future<bool> deleteCircular(int circularNo) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Response response = await _dio.delete(
        '${Api.updateCirculars}$circularNo',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 204) {
        status = ApiStatus.success;
        notifyListeners();
        SnackBarService.instance.showSnackBarSuccess('Deleted');
        return true;
      }
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }

  Future<VisitorRecordListModel> getAllVisitorRecord() async {
    status = ApiStatus.loading;
    notifyListeners();
    late VisitorRecordListModel recordModel;
    try {
      Response response = await _dio.get(
        Api.getNotifications,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        recordModel = VisitorRecordListModel.fromMap(response.data['data']);
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return recordModel;
  }

  Future<bool> sendVisitorNotification(Map reqBody) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Response response = await _dio.post(
        Api.sendNotification,
        data: json.encode(reqBody),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        SnackBarService.instance.showSnackBarSuccess(response.data['message']);
        return true;
      }
    } on DioError catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    return false;
  }
}
