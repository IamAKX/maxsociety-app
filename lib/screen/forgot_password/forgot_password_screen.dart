import 'package:flutter/material.dart';
import 'package:maxsociety/util/theme.dart';

import '../../widget/button_active.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/heading.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const String routePath = '/forgotPassword';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Recover password'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          'We will send a secure link for resetting password to your registered email',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        CustomTextField(
          hint: 'Email',
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          obscure: false,
          icon: Icons.email_outlined,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () {},
          label: 'Reset',
        ),
      ],
    );
  }
}
