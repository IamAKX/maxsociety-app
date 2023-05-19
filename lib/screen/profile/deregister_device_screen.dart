import 'package:flutter/material.dart';
import 'package:maxsociety/model/user_profile_model.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/preference_key.dart';
import '../../util/theme.dart';
import '../../widget/button_active.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/heading.dart';

class DeregisterDeviceScreen extends StatefulWidget {
  const DeregisterDeviceScreen({super.key});
  static const String routePath = '/deregisterDevice';

  @override
  State<DeregisterDeviceScreen> createState() => _DeregisterDeviceScreenState();
}

class _DeregisterDeviceScreenState extends State<DeregisterDeviceScreen> {
  late ApiProvider _api;
  final TextEditingController _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Deregister Device'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          'You are about to send request for de-registering this device. Your account will be vulnerable and can be access from any device',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: defaultPadding * 2,
        ),
        ActiveButton(
          onPressed: () async {
            UserProfile userProfile =
                UserProfile.fromJson(prefs.getString(PreferenceKey.user) ?? '');
            _api
                .createDeRegistrationRequest(
                    userProfile.userId!, userProfile.userName!)
                .then((value) {
              if (value) {
                Navigator.of(context).pop();
              }
            });
          },
          label: _api.status == ApiStatus.loading
              ? 'Please wait...'
              : 'Deregister',
          isDisabled: _api.status == ApiStatus.loading,
        ),
      ],
    );
  }
}
