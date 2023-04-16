import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:maxsociety/screen/event/visitor_notification_screen.dart';
import 'package:maxsociety/screen/security_guard/flat_list_screen.dart';
import 'package:maxsociety/util/enums.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/preference_key.dart';
import '../../widget/button_active.dart';
import '../../widget/heading.dart';

class AddVisitorScreen extends StatefulWidget {
  const AddVisitorScreen({super.key});

  @override
  State<AddVisitorScreen> createState() => _AddVisitorScreenState();
}

class _AddVisitorScreenState extends State<AddVisitorScreen> {
  UserProfile? userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  late ApiProvider _api;

  final TextEditingController _visitorNameCtrl = TextEditingController();
  final TextEditingController _purposeCtrl = TextEditingController();
  final TextEditingController _flatNoCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Visitor\'s Entry'),
      ),
      body: getBody(),
    );
  }

  getBody() {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          'Visitor Name',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        TextField(
          controller: _visitorNameCtrl,
          maxLines: 1,
          decoration: secondaryTextFieldDecoration('Visitor Name'),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Text(
          'Visit Purpose',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        TextField(
          controller: _purposeCtrl,
          maxLines: 2,
          decoration: textFieldDecoration('Visit Purpose'),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Text(
          'Flat Number',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        TextField(
          controller: _flatNoCtrl,
          maxLines: 1,
          onTap: () async {
            await Navigator.of(context)
                .pushNamed(FlatListScreen.routePath)
                .then((value) {
              _flatNoCtrl.text = (value == null ? '' : value as String);
              log('receiving : ${_flatNoCtrl.text}');
            });
          },
          decoration: textFieldDecoration('Flat Number'),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () async {
            if (_visitorNameCtrl.text.isEmpty ||
                _purposeCtrl.text.isEmpty ||
                _flatNoCtrl.text.isEmpty) {
              SnackBarService.instance
                  .showSnackBarError('All fields are mandatory');
              return;
            }

            Map<String, dynamic> reqBody = {
              "guardId": userProfile?.userId ?? '',
              "guardName": userProfile?.userName,
              "flatNo": _flatNoCtrl.text,
              "visitorName": _visitorNameCtrl.text,
              "visitPurpose": _purposeCtrl.text,
              "status": NotificationStatus.PENDING.name,
              "title": "You have a visitor",
              "body": '${_visitorNameCtrl.text} wants to visit your flat',
              "path": VisitorNotificationScreen.routePath
            };

            _api.sendVisitorNotification(reqBody).then((value) {
              if (value) {
                _visitorNameCtrl.text = '';
                _purposeCtrl.text = '';
                _flatNoCtrl.text = '';
              }
            });
          },
          label: _api.status == ApiStatus.loading
              ? 'Please wait...'
              : 'Request Permission',
          isDisabled: _api.status == ApiStatus.loading, //|| isImageUploading,
        )
      ],
    );
  }

  InputDecoration textFieldDecoration(String hint) {
    return InputDecoration(
      alignLabelWithHint: false,
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultPadding / 2),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1,
        ),
      ),
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultPadding / 2),
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
    );
  }
}
