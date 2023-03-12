import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/model/flat_model.dart';
import 'package:maxsociety/model/list/user_list_model.dart';
import 'package:maxsociety/model/user_profile_model.dart';
import 'package:maxsociety/model/vehicle_model.dart';
import 'package:maxsociety/service/snakbar_service.dart';
import 'package:maxsociety/util/api.dart';

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
      Response response = await _dio.post(
        Api.createUser,
        data: userProfile.toJson(),
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
      Response response = await _dio.put(
        Api.updateUser,
        data: userProfile.toJson(),
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
      Response response = await _dio.post(
        Api.createVehicles,
        data: vehicle.toJson(),
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
      Response response = await _dio.put(
        Api.updateVehicles,
        data: vehicle.toJson(),
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
}
