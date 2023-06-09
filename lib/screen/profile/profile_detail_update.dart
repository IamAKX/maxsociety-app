import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:maxsociety/main.dart';
import 'package:maxsociety/model/user_profile_model.dart';
import 'package:maxsociety/util/helper_methods.dart';
import 'package:maxsociety/util/preference_key.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/button_active.dart';
import 'package:maxsociety/widget/custom_textfield.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';

import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/constants.dart';
import '../../util/datetime_formatter.dart';

class ProfileDetailUpdateScreen extends StatefulWidget {
  const ProfileDetailUpdateScreen({super.key});
  static const String routePath = '/profileDetail';

  @override
  State<ProfileDetailUpdateScreen> createState() =>
      _ProfileDetailUpdateScreenState();
}

class _ProfileDetailUpdateScreenState extends State<ProfileDetailUpdateScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _flatNumberCtrl = TextEditingController();
  final TextEditingController _floorNumberCtrl = TextEditingController();
  final TextEditingController _blockCtrl = TextEditingController();
  final TextEditingController _carpetAreaCtrl = TextEditingController();
  final TextEditingController _superBuiltUpAreaCtrl = TextEditingController();
  final TextEditingController _dateOfBirthCtrl = TextEditingController();
  String _gender = genderList.first;
  UserProfile? userProfile;
  String dob = '';
  late ApiProvider _api;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadUser(),
    );
  }

  loadUser() {
    userProfile =
        UserProfile.fromJson(prefs.getString(PreferenceKey.user) ?? '');
    _nameCtrl.text = userProfile?.userName ?? '';
    _emailCtrl.text = userProfile?.email ?? '';
    _phoneCtrl.text = userProfile?.mobileNo ?? '';
    _gender = userProfile?.gender ?? '';
    _flatNumberCtrl.text = userProfile?.flats?.flatNo ?? '';
    _floorNumberCtrl.text = userProfile?.flats?.floor.toString() ?? '';
    _blockCtrl.text = userProfile?.flats?.wing ?? '';
    _superBuiltUpAreaCtrl.text = userProfile?.flats?.buitlUpArea ?? '';
    _carpetAreaCtrl.text = userProfile?.flats?.carpetArea ?? '';
    dob = eventDateToDate(userProfile?.dob ?? '');
    _dateOfBirthCtrl.text = dob;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Profile Detail'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    log('dob : $dob');
    log('parseServerTimestamp(userProfile?.dob ?? '
        ') : ${parseServerTimestamp(userProfile?.dob ?? '')}');
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          'PERSONAL DETAILS',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        CustomTextField(
          hint: 'Name',
          controller: _nameCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.person_outline,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        CustomTextField(
          hint: 'Email',
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          obscure: false,
          enabled: false,
          icon: Icons.email_outlined,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        CustomTextField(
          hint: 'Phone',
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          obscure: false,
          icon: Icons.phone_outlined,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Text(
          'Select gender',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        SizedBox(
          height: 50.0,
          child: RadioGroup<String>.builder(
            direction: Axis.horizontal,
            groupValue: _gender,
            horizontalAlignment: MainAxisAlignment.spaceAround,
            onChanged: (value) => setState(() {
              _gender = value ?? '';
            }),
            items: genderList,
            textStyle: Theme.of(context).textTheme.bodyLarge,
            itemBuilder: (item) => RadioButtonBuilder(
              item,
            ),
          ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Text(
          'Select Date of Birth',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        DateTimePicker(
          type: DateTimePickerType.date,
          initialValue: dob,
          // controller: _dateOfBirthCtrl,
          initialDate: parseServerTimestamp(userProfile?.dob ?? ''),
          firstDate: DateTime(DateTime.now().year - 100),
          lastDate: DateTime.now(),
          initialDatePickerMode: DatePickerMode.year,
          dateHintText: 'Date',
          timeHintText: 'Time',
          dateMask: 'd MMM, yyyy',
          calendarTitle: 'Date of Birth',
          onChanged: (val) => dob = val,
          validator: (val) {
            return null;
          },
          onSaved: (val) => dob = val!,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: primaryColor,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: defaultPadding * 2,
        ),
        if (!isGuardUser()) ...{
          Text(
            'FLAT DETAILS',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hint: 'Flat',
                  controller: _flatNumberCtrl,
                  keyboardType: TextInputType.none,
                  obscure: false,
                  enabled: false,
                  icon: Icons.home_outlined,
                ),
              ),
              const SizedBox(
                width: defaultPadding / 2,
              ),
              Expanded(
                child: CustomTextField(
                  hint: 'Floor',
                  controller: _floorNumberCtrl,
                  keyboardType: TextInputType.number,
                  obscure: false,
                  enabled: false,
                  icon: Icons.home_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          CustomTextField(
            hint: 'Block or Wing',
            controller: _blockCtrl,
            keyboardType: TextInputType.name,
            obscure: false,
            enabled: false,
            icon: Icons.home_outlined,
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          CustomTextField(
            hint: 'Super built-up area in sqft',
            controller: _superBuiltUpAreaCtrl,
            keyboardType: TextInputType.number,
            obscure: false,
            enabled: false,
            icon: Icons.home_outlined,
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          CustomTextField(
            hint: 'Carpet area in sqft',
            controller: _carpetAreaCtrl,
            keyboardType: TextInputType.number,
            obscure: false,
            enabled: false,
            icon: Icons.home_outlined,
          ),
          const SizedBox(
            height: defaultPadding,
          ),
        },
        ActiveButton(
          onPressed: () async {
            if (_nameCtrl.text.isEmpty ||
                _phoneCtrl.text.isEmpty ||
                dob.isEmpty) {
              SnackBarService.instance
                  .showSnackBarError('None of the field can be empty');
              return;
            }
            try {
              log(dob);
              dob = formatFromDatepickerToDatabaseOnlyDate(dob);
            } catch (e) {
              SnackBarService.instance
                  .showSnackBarError('Enter date and time of the event');
              return;
            }
            userProfile?.userName = _nameCtrl.text;
            userProfile?.mobileNo = _phoneCtrl.text;
            userProfile?.gender = _gender;
            userProfile?.dob = dob;
            _api.updateUser(userProfile!).then((value) {
              if (value) {
                userProfile?.userName = _nameCtrl.text;
                userProfile?.mobileNo = _phoneCtrl.text;
                userProfile?.gender = _gender;
                userProfile?.dob = dob;
                prefs.setString(
                    PreferenceKey.user, userProfile?.toJson() ?? '');
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
