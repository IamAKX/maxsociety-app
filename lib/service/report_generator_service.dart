import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maxsociety/model/user_profile_model.dart';
import 'package:maxsociety/service/api_service.dart';
import 'package:maxsociety/service/snakbar_service.dart';
import 'package:maxsociety/util/datetime_formatter.dart';
import 'package:maxsociety/util/enums.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../model/circular_model.dart';
import '../model/visitors_record_model.dart';

enum ReportGeneratorStatus { ideal, loading, success, failed }

class ReportGeneratorProvider extends ChangeNotifier {
  ReportGeneratorStatus? status = ReportGeneratorStatus.ideal;
  String filePath = '';

  static ReportGeneratorProvider instance = ReportGeneratorProvider();

  Future<bool> generateCircularReport() async {
    if (Platform.isIOS) {
      await getApplicationDocumentsDirectory().then((dir) => dir.path);
    } else {
      filePath = '/storage/emulated/0/Download';
    }
    SnackBarService.instance
        .showSnackBarInfo('Generating report, please wait...');

    status = ReportGeneratorStatus.loading;
    notifyListeners();
    try {
      List<CircularModel> circularList = [];
      await ApiProvider.instance.getCirculars().then((value) {
        circularList = value.data ?? [];
      });
      if (circularList.isEmpty) {
        SnackBarService.instance.showSnackBarError('No data to export');
        status = ReportGeneratorStatus.ideal;
        notifyListeners();
        return false;
      }

      Map<String, List<CircularModel>> circularMap = {};
      for (CircularModel c in circularList) {
        circularMap.update(
          c.circularType ?? '',
          (value) => List.from(value)..add(c),
          ifAbsent: () => [c],
        );
      }
      List<String> headers = [
        'No',
        'Event Date',
        'Created Name',
        'Creator Phone',
        'Creator Flat',
        'Creator Block',
        'Creator Floor',
        'Creator Type',
        'Created on',
        'Category',
        'Image',
        'Title',
        'Content',
      ];
      final Workbook workbook = Workbook(circularMap.keys.length);
      Style globalStyle = workbook.styles.add('style');
      globalStyle.bold = true;
      for (var index = 0; index < circularMap.keys.length; index++) {
        final Worksheet sheet = workbook.worksheets[index];
        String cName = circularMap.keys.elementAt(index);

        List<CircularModel> cList = circularMap[cName]!;
        sheet.name = cName;
        // Adding header

        for (var hIndex = 0; hIndex < headers.length; hIndex++) {
          sheet
              .getRangeByIndex(1, hIndex + 1)
              .setText(headers.elementAt(hIndex));
          sheet.getRangeByIndex(1, hIndex + 1).cellStyle = globalStyle;
        }
        for (var rIndex = 0; rIndex < cList.length; rIndex++) {
          CircularModel c = cList.elementAt(rIndex);

          sheet.getRangeByIndex(rIndex + 2, 1).setText(c.circularNo);

          sheet
              .getRangeByIndex(rIndex + 2, 2)
              .setText(reportDateFormat(c.eventDate ?? ''));
          sheet
              .getRangeByIndex(rIndex + 2, 3)
              .setText(c.createdBy?.userName ?? '');
          sheet
              .getRangeByIndex(rIndex + 2, 4)
              .setText(c.createdBy?.mobileNo ?? '');
          sheet
              .getRangeByIndex(rIndex + 2, 5)
              .setText(c.createdBy?.flats?.flatNo);
          sheet
              .getRangeByIndex(rIndex + 2, 6)
              .setText(c.createdBy?.flats?.tower);
          sheet
              .getRangeByIndex(rIndex + 2, 7)
              .setText(c.createdBy?.flats?.floor.toString());
          sheet.getRangeByIndex(rIndex + 2, 8).setText(
              c.createdBy?.roles?.map((e) => e.name).toList().toString());
          sheet
              .getRangeByIndex(rIndex + 2, 9)
              .setText(reportDateFormat(c.createdOn ?? ''));
          sheet.getRangeByIndex(rIndex + 2, 10).setText(c.circularCategory);
          String imgUrl = (c.circularImages?.isEmpty ?? true)
              ? ''
              : c.circularImages?.first.imageUrl ?? '';
          if (imgUrl.isEmpty) {
            sheet.getRangeByIndex(rIndex + 2, 11).setText('');
          } else {
            final Hyperlink hyperlink = sheet.hyperlinks.add(
                sheet.getRangeByIndex(rIndex + 2, 11),
                HyperlinkType.url,
                imgUrl);
            hyperlink.screenTip = 'View Image';
            hyperlink.textToDisplay = 'View Image';
          }
          sheet.getRangeByIndex(rIndex + 2, 12).setText(c.subject);
          sheet.getRangeByIndex(rIndex + 2, 13).setText(c.circularText);
          int col = 1;
          while (col <= 13) {
            sheet.autoFitColumn(col);
            col++;
          }
        }
      }
      final List<int> bytes = workbook.saveAsStream();
      File('$filePath/Circular_${currentDateForFileName()}.xlsx')
          .writeAsBytes(bytes);

      workbook.dispose();
      SnackBarService.instance.showSnackBarSuccess('Report generated');
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
      return true;
    } catch (e) {
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
    }
    return false;
  }

  Future<bool> generateServiceRequestReport() async {
    if (Platform.isIOS) {
      await getApplicationDocumentsDirectory().then((dir) => dir.path);
    } else {
      filePath = '/storage/emulated/0/Download';
    }
    SnackBarService.instance
        .showSnackBarInfo('Generating report, please wait...');

    status = ReportGeneratorStatus.loading;
    notifyListeners();
    try {
      List<CircularModel> circularList = [];
      await ApiProvider.instance
          .getCircularsByCircularType(CircularType.SERVICE_REQUEST.name)
          .then((value) {
        circularList = value.data ?? [];
      });
      if (circularList.isEmpty) {
        SnackBarService.instance.showSnackBarError('No data to export');
        status = ReportGeneratorStatus.ideal;
        notifyListeners();
        return false;
      }

      Map<String, List<CircularModel>> circularMap = {};
      for (CircularModel c in circularList) {
        circularMap.update(
          c.circularType ?? '',
          (value) => List.from(value)..add(c),
          ifAbsent: () => [c],
        );
      }
      List<String> headers = [
        'No',
        'Event Date',
        'Created Name',
        'Creator Phone',
        'Creator Flat',
        'Creator Block',
        'Creator Floor',
        'Creator Type',
        'Created on',
        'Category',
        'Image',
        'Title',
        'Content',
      ];
      final Workbook workbook = Workbook(circularMap.keys.length);
      Style globalStyle = workbook.styles.add('style');
      globalStyle.bold = true;
      for (var index = 0; index < circularMap.keys.length; index++) {
        final Worksheet sheet = workbook.worksheets[index];
        String cName = circularMap.keys.elementAt(index);

        List<CircularModel> cList = circularMap[cName]!;
        sheet.name = cName;
        // Adding header

        for (var hIndex = 0; hIndex < headers.length; hIndex++) {
          sheet
              .getRangeByIndex(1, hIndex + 1)
              .setText(headers.elementAt(hIndex));
          sheet.getRangeByIndex(1, hIndex + 1).cellStyle = globalStyle;
        }
        for (var rIndex = 0; rIndex < cList.length; rIndex++) {
          CircularModel c = cList.elementAt(rIndex);

          sheet.getRangeByIndex(rIndex + 2, 1).setText(c.circularNo);

          sheet
              .getRangeByIndex(rIndex + 2, 2)
              .setText(reportDateFormat(c.eventDate ?? ''));
          sheet
              .getRangeByIndex(rIndex + 2, 3)
              .setText(c.createdBy?.userName ?? '');
          sheet
              .getRangeByIndex(rIndex + 2, 4)
              .setText(c.createdBy?.mobileNo ?? '');
          sheet
              .getRangeByIndex(rIndex + 2, 5)
              .setText(c.createdBy?.flats?.flatNo);
          sheet
              .getRangeByIndex(rIndex + 2, 6)
              .setText(c.createdBy?.flats?.tower);
          sheet
              .getRangeByIndex(rIndex + 2, 7)
              .setText(c.createdBy?.flats?.floor.toString());
          sheet.getRangeByIndex(rIndex + 2, 8).setText(
              c.createdBy?.roles?.map((e) => e.name).toList().toString());
          sheet
              .getRangeByIndex(rIndex + 2, 9)
              .setText(reportDateFormat(c.createdOn ?? ''));
          sheet.getRangeByIndex(rIndex + 2, 10).setText(c.circularCategory);
          String imgUrl = (c.circularImages?.isEmpty ?? true)
              ? ''
              : c.circularImages?.first.imageUrl ?? '';
          if (imgUrl.isEmpty) {
            sheet.getRangeByIndex(rIndex + 2, 11).setText('');
          } else {
            final Hyperlink hyperlink = sheet.hyperlinks.add(
                sheet.getRangeByIndex(rIndex + 2, 11),
                HyperlinkType.url,
                imgUrl);
            hyperlink.screenTip = 'View Image';
            hyperlink.textToDisplay = 'View Image';
          }
          sheet.getRangeByIndex(rIndex + 2, 12).setText(c.subject);
          sheet.getRangeByIndex(rIndex + 2, 13).setText(c.circularText);
          int col = 1;
          while (col <= 13) {
            sheet.autoFitColumn(col);
            col++;
          }
        }
      }
      final List<int> bytes = workbook.saveAsStream();
      File('$filePath/Service_Request_${currentDateForFileName()}.xlsx')
          .writeAsBytes(bytes);

      workbook.dispose();
      SnackBarService.instance.showSnackBarSuccess('Report generated');
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
      return true;
    } catch (e) {
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
    }
    return false;
  }

  Future<bool> generateComplaintReport() async {
    if (Platform.isIOS) {
      await getApplicationDocumentsDirectory().then((dir) => dir.path);
    } else {
      filePath = '/storage/emulated/0/Download';
    }
    SnackBarService.instance
        .showSnackBarInfo('Generating report, please wait...');

    status = ReportGeneratorStatus.loading;
    notifyListeners();
    try {
      List<CircularModel> circularList = [];
      await ApiProvider.instance
          .getCircularsByCircularType(CircularType.SERVICE_REQUEST.name)
          .then((value) {
        circularList = value.data ?? [];
        circularList
            .removeWhere((element) => element.circularCategory != 'Complaint');
      });
      if (circularList.isEmpty) {
        SnackBarService.instance.showSnackBarError('No data to export');
        status = ReportGeneratorStatus.ideal;
        notifyListeners();
        return false;
      }

      Map<String, List<CircularModel>> circularMap = {};
      for (CircularModel c in circularList) {
        circularMap.update(
          c.circularType ?? '',
          (value) => List.from(value)..add(c),
          ifAbsent: () => [c],
        );
      }
      List<String> headers = [
        'No',
        'Event Date',
        'Created Name',
        'Creator Phone',
        'Creator Flat',
        'Creator Block',
        'Creator Floor',
        'Creator Type',
        'Created on',
        'Category',
        'Image',
        'Title',
        'Content',
      ];
      final Workbook workbook = Workbook(circularMap.keys.length);
      Style globalStyle = workbook.styles.add('style');
      globalStyle.bold = true;
      for (var index = 0; index < circularMap.keys.length; index++) {
        final Worksheet sheet = workbook.worksheets[index];
        String cName = circularMap.keys.elementAt(index);

        List<CircularModel> cList = circularMap[cName]!;
        sheet.name = cName;
        // Adding header

        for (var hIndex = 0; hIndex < headers.length; hIndex++) {
          sheet
              .getRangeByIndex(1, hIndex + 1)
              .setText(headers.elementAt(hIndex));
          sheet.getRangeByIndex(1, hIndex + 1).cellStyle = globalStyle;
        }
        for (var rIndex = 0; rIndex < cList.length; rIndex++) {
          CircularModel c = cList.elementAt(rIndex);

          sheet.getRangeByIndex(rIndex + 2, 1).setText(c.circularNo);

          sheet
              .getRangeByIndex(rIndex + 2, 2)
              .setText(reportDateFormat(c.eventDate ?? ''));
          sheet
              .getRangeByIndex(rIndex + 2, 3)
              .setText(c.createdBy?.userName ?? '');
          sheet
              .getRangeByIndex(rIndex + 2, 4)
              .setText(c.createdBy?.mobileNo ?? '');
          sheet
              .getRangeByIndex(rIndex + 2, 5)
              .setText(c.createdBy?.flats?.flatNo);
          sheet
              .getRangeByIndex(rIndex + 2, 6)
              .setText(c.createdBy?.flats?.tower);
          sheet
              .getRangeByIndex(rIndex + 2, 7)
              .setText(c.createdBy?.flats?.floor.toString());
          sheet.getRangeByIndex(rIndex + 2, 8).setText(
              c.createdBy?.roles?.map((e) => e.name).toList().toString());
          sheet
              .getRangeByIndex(rIndex + 2, 9)
              .setText(reportDateFormat(c.createdOn ?? ''));
          sheet.getRangeByIndex(rIndex + 2, 10).setText(c.circularCategory);
          String imgUrl = (c.circularImages?.isEmpty ?? true)
              ? ''
              : c.circularImages?.first.imageUrl ?? '';
          if (imgUrl.isEmpty) {
            sheet.getRangeByIndex(rIndex + 2, 11).setText('');
          } else {
            final Hyperlink hyperlink = sheet.hyperlinks.add(
                sheet.getRangeByIndex(rIndex + 2, 11),
                HyperlinkType.url,
                imgUrl);
            hyperlink.screenTip = 'View Image';
            hyperlink.textToDisplay = 'View Image';
          }
          sheet.getRangeByIndex(rIndex + 2, 12).setText(c.subject);
          sheet.getRangeByIndex(rIndex + 2, 13).setText(c.circularText);
          int col = 1;
          while (col <= 13) {
            sheet.autoFitColumn(col);
            col++;
          }
        }
      }
      final List<int> bytes = workbook.saveAsStream();
      File('$filePath/Complaint_${currentDateForFileName()}.xlsx')
          .writeAsBytes(bytes);

      workbook.dispose();
      SnackBarService.instance.showSnackBarSuccess('Report generated');
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
      return true;
    } catch (e) {
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
    }
    return false;
  }

  Future<bool> generateSocietyMemberReport(String userRole) async {
    if (Platform.isIOS) {
      await getApplicationDocumentsDirectory().then((dir) => dir.path);
    } else {
      filePath = '/storage/emulated/0/Download';
    }
    SnackBarService.instance
        .showSnackBarInfo('Generating report, please wait...');

    status = ReportGeneratorStatus.loading;
    notifyListeners();
    try {
      List<UserProfile> userList = [];
      await ApiProvider.instance.getUsersByRole(userRole).then((value) {
        userList = value.data ?? [];
      });
      if (userList.isEmpty) {
        SnackBarService.instance.showSnackBarError('No data to export');
        status = ReportGeneratorStatus.ideal;
        notifyListeners();
        return false;
      }

      List<String> headers = [
        'Name',
        'Contact',
        'Email',
        'Gender',
        'DOB',
        'Flat No',
        'Floor',
        'Block',
        'Vehicles',
        'Family',
        'Profile Image',
        'Onboarded On',
        'Designation',
        'Category',
      ];
      final Workbook workbook = Workbook();
      Style globalStyle = workbook.styles.add('style');
      globalStyle.bold = true;
      final Worksheet sheet = workbook.worksheets[0];
      String cName = '$userRole MEMBERS';

      sheet.name = cName;
      // Adding header
      for (var hIndex = 0; hIndex < headers.length; hIndex++) {
        sheet.getRangeByIndex(1, hIndex + 1).setText(headers.elementAt(hIndex));
        sheet.getRangeByIndex(1, hIndex + 1).cellStyle = globalStyle;
      }
      for (var rIndex = 0; rIndex < userList.length; rIndex++) {
        UserProfile c = userList.elementAt(rIndex);

        sheet.getRangeByIndex(rIndex + 2, 1).setText(c.userName);

        sheet.getRangeByIndex(rIndex + 2, 2).setText(c.mobileNo ?? '');
        sheet.getRangeByIndex(rIndex + 2, 3).setText(c.email ?? '');
        sheet.getRangeByIndex(rIndex + 2, 4).setText(c.gender ?? '');
        sheet
            .getRangeByIndex(rIndex + 2, 5)
            .setText(eventDateToDate(c.dob ?? ''));
        sheet.getRangeByIndex(rIndex + 2, 6).setText(c.flats?.flatNo);
        sheet.getRangeByIndex(rIndex + 2, 7).setText(c.flats?.floor.toString());
        sheet.getRangeByIndex(rIndex + 2, 8).setText(c.flats?.tower ?? '');
        sheet
            .getRangeByIndex(rIndex + 2, 9)
            .setText(c.flats?.vehicles?.length.toString() ?? '0');
        sheet
            .getRangeByIndex(rIndex + 2, 10)
            .setText(c.familyMembersCount.toString());
        String imgUrl = (c.imagePath?.isEmpty ?? true) ? '' : c.imagePath ?? '';
        if (imgUrl.isEmpty) {
          sheet.getRangeByIndex(rIndex + 2, 11).setText('');
        } else {
          final Hyperlink hyperlink = sheet.hyperlinks.add(
              sheet.getRangeByIndex(rIndex + 2, 11), HyperlinkType.url, imgUrl);
          hyperlink.screenTip = 'View Profile Image';
          hyperlink.textToDisplay = 'View Profile Image';
        }
        sheet
            .getRangeByIndex(rIndex + 2, 12)
            .setText(eventDateToDateTime(c.createdOn ?? ''));
        sheet.getRangeByIndex(rIndex + 2, 13).setText(c.designation);
        sheet.getRangeByIndex(rIndex + 2, 14).setText(c.category);
        int col = 1;
        while (col <= 14) {
          sheet.autoFitColumn(col);
          col++;
        }
      }
      final List<int> bytes = workbook.saveAsStream();
      File('$filePath/$userRole${currentDateForFileName()}.xlsx')
          .writeAsBytes(bytes);

      workbook.dispose();
      SnackBarService.instance.showSnackBarSuccess('Report generated');
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
      return true;
    } catch (e) {
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
    }
    return false;
  }

  Future<bool> generateTenantMemberReport() async {
    if (Platform.isIOS) {
      await getApplicationDocumentsDirectory().then((dir) => dir.path);
    } else {
      filePath = '/storage/emulated/0/Download';
    }
    SnackBarService.instance
        .showSnackBarInfo('Generating report, please wait...');

    status = ReportGeneratorStatus.loading;
    notifyListeners();
    try {
      List<UserProfile> userList = [];
      await ApiProvider.instance.getAllUserMember().then((value) {
        userList = value.data ?? [];
        userList.removeWhere((element) => element.relationship != 'TENANT');
      });
      if (userList.isEmpty) {
        SnackBarService.instance.showSnackBarError('No data to export');
        status = ReportGeneratorStatus.ideal;
        notifyListeners();
        return false;
      }

      List<String> headers = [
        'Name',
        'Contact',
        'Email',
        'Gender',
        'DOB',
        'Flat No',
        'Floor',
        'Block',
        'Vehicles',
        'Family',
        'Profile Image',
        'Onboarded On',
        'Designation',
        'Category',
      ];
      final Workbook workbook = Workbook();
      Style globalStyle = workbook.styles.add('style');
      globalStyle.bold = true;
      final Worksheet sheet = workbook.worksheets[0];
      String cName = 'TENANTS';

      sheet.name = cName;
      // Adding header
      for (var hIndex = 0; hIndex < headers.length; hIndex++) {
        sheet.getRangeByIndex(1, hIndex + 1).setText(headers.elementAt(hIndex));
        sheet.getRangeByIndex(1, hIndex + 1).cellStyle = globalStyle;
      }
      for (var rIndex = 0; rIndex < userList.length; rIndex++) {
        UserProfile c = userList.elementAt(rIndex);

        sheet.getRangeByIndex(rIndex + 2, 1).setText(c.userName);

        sheet.getRangeByIndex(rIndex + 2, 2).setText(c.mobileNo ?? '');
        sheet.getRangeByIndex(rIndex + 2, 3).setText(c.email ?? '');
        sheet.getRangeByIndex(rIndex + 2, 4).setText(c.gender ?? '');
        sheet
            .getRangeByIndex(rIndex + 2, 5)
            .setText(eventDateToDate(c.dob ?? ''));
        sheet.getRangeByIndex(rIndex + 2, 6).setText(c.flats?.flatNo);
        sheet.getRangeByIndex(rIndex + 2, 7).setText(c.flats?.floor.toString());
        sheet.getRangeByIndex(rIndex + 2, 8).setText(c.flats?.tower ?? '');
        sheet
            .getRangeByIndex(rIndex + 2, 9)
            .setText(c.flats?.vehicles?.length.toString() ?? '0');
        sheet
            .getRangeByIndex(rIndex + 2, 10)
            .setText(c.familyMembersCount.toString());
        String imgUrl = (c.imagePath?.isEmpty ?? true) ? '' : c.imagePath ?? '';
        if (imgUrl.isEmpty) {
          sheet.getRangeByIndex(rIndex + 2, 11).setText('');
        } else {
          final Hyperlink hyperlink = sheet.hyperlinks.add(
              sheet.getRangeByIndex(rIndex + 2, 11), HyperlinkType.url, imgUrl);
          hyperlink.screenTip = 'View Profile Image';
          hyperlink.textToDisplay = 'View Profile Image';
        }
        sheet
            .getRangeByIndex(rIndex + 2, 12)
            .setText(eventDateToDateTime(c.createdOn ?? ''));
        sheet.getRangeByIndex(rIndex + 2, 13).setText(c.designation);
        sheet.getRangeByIndex(rIndex + 2, 14).setText(c.category);
        int col = 1;
        while (col <= 14) {
          sheet.autoFitColumn(col);
          col++;
        }
      }
      final List<int> bytes = workbook.saveAsStream();
      File('$filePath/TenantMember_${currentDateForFileName()}.xlsx')
          .writeAsBytes(bytes);

      workbook.dispose();
      SnackBarService.instance.showSnackBarSuccess('Report generated');
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
      return true;
    } catch (e) {
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
    }
    return false;
  }

  Future<bool> generateVisitorReport() async {
    if (Platform.isIOS) {
      await getApplicationDocumentsDirectory().then((dir) => dir.path);
    } else {
      filePath = '/storage/emulated/0/Download';
    }
    SnackBarService.instance
        .showSnackBarInfo('Generating report, please wait...');

    status = ReportGeneratorStatus.loading;
    notifyListeners();
    try {
      List<VisiorsRecordModel> record = [];
      await ApiProvider.instance.getAllVisitorRecord().then((value) {
        record = value.gateKeepRequests ?? [];
      });
      if (record.isEmpty) {
        SnackBarService.instance.showSnackBarError('No data to export');
        status = ReportGeneratorStatus.ideal;
        notifyListeners();
        return false;
      }

      List<String> headers = [
        'Flat No',
        'Visitor Name',
        'Visit Purpose',
        'Guard Number',
        'Visit Time',
        'Action Time',
        'Status',
      ];
      final Workbook workbook = Workbook();
      Style globalStyle = workbook.styles.add('style');
      globalStyle.bold = true;
      final Worksheet sheet = workbook.worksheets[0];
      String cName = 'Visitor';

      sheet.name = cName;
      // Adding header
      for (var hIndex = 0; hIndex < headers.length; hIndex++) {
        sheet.getRangeByIndex(1, hIndex + 1).setText(headers.elementAt(hIndex));
        sheet.getRangeByIndex(1, hIndex + 1).cellStyle = globalStyle;
      }
      for (var rIndex = 0; rIndex < record.length; rIndex++) {
        VisiorsRecordModel c = record.elementAt(rIndex);

        sheet.getRangeByIndex(rIndex + 2, 1).setText(c.flatNo);

        sheet.getRangeByIndex(rIndex + 2, 2).setText(c.visitorName ?? '');
        sheet.getRangeByIndex(rIndex + 2, 3).setText(c.visitPurpose ?? '');
        sheet.getRangeByIndex(rIndex + 2, 4).setText(c.guardName ?? '');
        sheet
            .getRangeByIndex(rIndex + 2, 5)
            .setText(eventDateToDateTime(c.gkReqInitTime ?? ''));
        sheet
            .getRangeByIndex(rIndex + 2, 6)
            .setText(eventDateToDateTime(c.gkReqActionTime ?? ''));
        sheet.getRangeByIndex(rIndex + 2, 7).setText(c.status);

        int col = 1;
        while (col <= 7) {
          sheet.autoFitColumn(col);
          col++;
        }
      }
      final List<int> bytes = workbook.saveAsStream();
      File('$filePath/$cName${currentDateForFileName()}.xlsx')
          .writeAsBytes(bytes);

      workbook.dispose();
      SnackBarService.instance.showSnackBarSuccess('Report generated');
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
      return true;
    } catch (e) {
      status = ReportGeneratorStatus.ideal;
      notifyListeners();
    }
    return false;
  }
}
