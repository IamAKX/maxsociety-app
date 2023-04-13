import 'package:flutter/material.dart';
import 'package:maxsociety/main.dart';
import 'package:maxsociety/model/user_profile_model.dart';
import 'package:maxsociety/screen/forgot_password/forgot_password_screen.dart';
import 'package:maxsociety/screen/login/login_message.dart';
import 'package:maxsociety/screen/login/notice_row.dart';
import 'package:maxsociety/screen/security_guard/guard_main_container.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/preference_key.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/button_active.dart';
import 'package:maxsociety/widget/custom_textfield.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:maxsociety/widget/main_container.dart';
import 'package:provider/provider.dart';

import '../../service/auth_service.dart';
import '../../service/snakbar_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routePath = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  late AuthProvider _auth;

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Get Started!'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        CustomTextField(
          hint: 'Email',
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          obscure: false,
          icon: Icons.email_outlined,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        CustomTextField(
          hint: 'Password',
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
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     MainContainer.routePath, (route) => false);
            // await _auth.registerUserWithEmailAndPassword(
            //     'Admin', 'maxsocietyimp@gmail.com', 'admin123');
            await _auth
                .loginUserWithEmailAndPassword(
                    _emailCtrl.text.trim(), _passwordCtrl.text.trim())
                .then((value) {
              if (_auth.status == AuthStatus.authenticated &&
                  prefs.containsKey(PreferenceKey.user)) {
                // ignore: no_leading_underscores_for_local_identifiers
                UserProfile _userProfile = UserProfile.fromJson(
                    prefs.getString(PreferenceKey.user) ?? '');
                if (_userProfile.roles?.any((element) => element.id == 4) ??
                    false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      GuardMainContainer.routePath, (route) => false);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      MainContainer.routePath, (route) => false);
                }
              }
            });
          },
          label: _auth.status == AuthStatus.authenticating
              ? 'Please wait...'
              : 'Login',
          isDisabled: _auth.status == AuthStatus.authenticating,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(ForgotPasswordScreen.routePath);
          },
          child: const Text('Forgot Password'),
        ),
        const SizedBox(
          height: defaultPadding * 3,
        ),
        Container(
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(defaultPadding / 2),
          ),
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/logo/logo_64.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(
                    width: defaultPadding / 2,
                  ),
                  Text(
                    'MaxSociety',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  )
                ],
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              for (String text in LoginMessage.noticeList) ...{
                NoticeRows(text: text),
              },
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Privacy Policy'),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
