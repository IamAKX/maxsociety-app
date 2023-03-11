import 'package:flutter/material.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/button_active.dart';
import 'package:maxsociety/widget/custom_textfield.dart';

import '../../widget/heading.dart';

class SocietyDetails extends StatefulWidget {
  const SocietyDetails({super.key});
  static const String routePath = '/adminControls/societyDetail';

  @override
  State<SocietyDetails> createState() => _SocietyDetailsState();
}

class _SocietyDetailsState extends State<SocietyDetails> {
  final TextEditingController _societyNameCtrl = TextEditingController();
  final TextEditingController _addressLine1Ctrl = TextEditingController();
  final TextEditingController _addressLine2Ctrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();
  final TextEditingController _stateCtrl = TextEditingController();
  final TextEditingController _zipcodeCtrl = TextEditingController();
  final TextEditingController _regDateCtrl = TextEditingController();
  final TextEditingController _reraRegNoCtrl = TextEditingController();
  final TextEditingController _societyRegNoCtrl = TextEditingController();
  final TextEditingController _wardNoCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Society Details'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          'ADDRESS',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        CustomTextField(
          hint: 'Society Name',
          controller: _societyNameCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.home_work_outlined,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        CustomTextField(
          hint: 'Address Line 1',
          controller: _addressLine1Ctrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.home_work_outlined,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        CustomTextField(
          hint: 'Address Line 2',
          controller: _addressLine2Ctrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.home_work_outlined,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        CustomTextField(
          hint: 'City',
          controller: _cityCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.home_work_outlined,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        CustomTextField(
          hint: 'State',
          controller: _stateCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.home_work_outlined,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        CustomTextField(
          hint: 'Zip code',
          controller: _zipcodeCtrl,
          keyboardType: TextInputType.number,
          obscure: false,
          icon: Icons.home_work_outlined,
        ),
        const SizedBox(
          height: defaultPadding * 1.5,
        ),
        Text(
          'SOCIETY DETAILS',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        CustomTextField(
          hint: 'Registration Date',
          controller: _regDateCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.home_work_outlined,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        CustomTextField(
          hint: 'Rera Reg. No',
          controller: _reraRegNoCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.home_work_outlined,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        CustomTextField(
          hint: 'Society Registration No',
          controller: _societyNameCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.home_work_outlined,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        CustomTextField(
          hint: 'Ward Number',
          controller: _wardNoCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.home_work_outlined,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () {},
          label: 'Update',
        )
      ],
    );
  }
}
