import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/auth_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/theme.dart';
import '../../widget/button_active.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/heading.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  static const String routePath = '/changePassword';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late AuthProvider _auth;
  final TextEditingController _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Change password'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          'Enter new password',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        CustomTextField(
          hint: 'New Password',
          controller: _passwordCtrl,
          keyboardType: TextInputType.visiblePassword,
          obscure: true,
          icon: Icons.lock_outline,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () async {
            _auth.updatePassword(_passwordCtrl.text).then((value) {
              if (value) {
                Navigator.of(context).pop();
              }
            });
          },
          label: _auth.status == AuthStatus.authenticating
              ? 'Please wait...'
              : 'Change',
          isDisabled: _auth.status == AuthStatus.authenticating,
        ),
      ],
    );
  }
}
