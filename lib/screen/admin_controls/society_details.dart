import 'package:flutter/material.dart';
import 'package:maxsociety/model/society_address_model.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/button_active.dart';
import 'package:maxsociety/widget/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../../model/society_detail_model.dart';
import '../../model/society_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../widget/heading.dart';

class SocietyDetails extends StatefulWidget {
  const SocietyDetails({super.key});
  static const String routePath = '/adminControls/societyDetail';

  @override
  State<SocietyDetails> createState() => _SocietyDetailsState();
}

class _SocietyDetailsState extends State<SocietyDetails> {
  late ApiProvider _api;
  SocietyModel? societyModel;

  final TextEditingController _societyNameCtrl = TextEditingController();
  final TextEditingController _addressLine1Ctrl = TextEditingController();
  final TextEditingController _addressLine2Ctrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();
  final TextEditingController _stateCtrl = TextEditingController();
  final TextEditingController _zipcodeCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _reraRegNoCtrl = TextEditingController();
  final TextEditingController _societyRegNoCtrl = TextEditingController();
  final TextEditingController _wardNoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadSocietData(),
    );
  }

  loadSocietData() async {
    societyModel = await _api.getSociety();
    _societyNameCtrl.text = societyModel?.societyDetails?.societyName ?? '';
    _addressLine1Ctrl.text = societyModel?.address?.addressLine1 ?? '';
    _addressLine2Ctrl.text = societyModel?.address?.addressLine2 ?? '';
    _cityCtrl.text = societyModel?.address?.city ?? '';
    _stateCtrl.text = societyModel?.address?.state ?? '';
    _zipcodeCtrl.text = societyModel?.address?.zipCode ?? '';
    _phoneCtrl.text = societyModel?.phoneNo ?? '';
    _reraRegNoCtrl.text = societyModel?.societyDetails?.reraRegNo ?? '';
    _societyRegNoCtrl.text = societyModel?.societyDetails?.reraRegNo ?? '';
    _wardNoCtrl.text = societyModel?.societyDetails?.wardNo ?? '';

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
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
          hint: 'Offical Phone number',
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          obscure: false,
          icon: Icons.phone_outlined,
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
          controller: _societyRegNoCtrl,
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
          onPressed: () async {
            if (_societyNameCtrl.text.isEmpty ||
                _addressLine1Ctrl.text.isEmpty ||
                _addressLine2Ctrl.text.isEmpty ||
                _cityCtrl.text.isEmpty ||
                _stateCtrl.text.isEmpty ||
                _zipcodeCtrl.text.isEmpty ||
                _phoneCtrl.text.isEmpty ||
                _reraRegNoCtrl.text.isEmpty ||
                _societyRegNoCtrl.text.isEmpty ||
                _wardNoCtrl.text.isEmpty) {
              SnackBarService.instance
                  .showSnackBarError('All fields are mandatory');
              return;
            }

            SocietyModel updatedSociety = SocietyModel(
              phoneNo: _phoneCtrl.text,
              societyCode: 1,
              address: SocietyAddressModel(
                addressLine1: _addressLine1Ctrl.text,
                addressLine2: _addressLine2Ctrl.text,
                city: _cityCtrl.text,
                state: _stateCtrl.text,
                zipCode: _zipcodeCtrl.text,
              ),
              societyDetails: SocietyDetailModel(
                imagePath: societyModel?.societyDetails?.imagePath ?? '',
                reraRegNo: _reraRegNoCtrl.text,
                societyName: _societyNameCtrl.text,
                societyRegNo: _societyRegNoCtrl.text,
                wardNo: _wardNoCtrl.text,
              ),
            );
            await _api.updateSociety(updatedSociety).then((value) {
              if (value) {
                Navigator.of(context).pop();
              }
            });
          },
          label: _api.status == ApiStatus.loading ? 'Please wait...' : 'Update',
          isDisabled: _api.status == ApiStatus.loading,
        )
      ],
    );
  }
}
