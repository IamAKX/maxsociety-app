import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:maxsociety/model/flat_model.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/constants.dart';
import '../../util/preference_key.dart';
import '../../util/theme.dart';
import '../../widget/button_active.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/heading.dart';

class CreateSocietyMemberScreen extends StatefulWidget {
  const CreateSocietyMemberScreen({super.key});
  static const String routePath = '/adminControls/SocietyMember/create';

  @override
  State<CreateSocietyMemberScreen> createState() =>
      _CreateSocietyMemberScreenState();
}

class _CreateSocietyMemberScreenState extends State<CreateSocietyMemberScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _flatNumberCtrl = TextEditingController();
  final TextEditingController _floorNumberCtrl = TextEditingController();
  final TextEditingController _blockCtrl = TextEditingController();
  final TextEditingController _carpetAreaCtrl = TextEditingController();
  final TextEditingController _superBuiltUpAreaCtrl = TextEditingController();
  String _gender = genderList.first;
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  late ApiProvider _api;
  late AuthProvider _auth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _flatNumberCtrl.addListener(() async {
      if (_flatNumberCtrl.text.length > 3) {
        await _api.getFlatByFlatNo(_flatNumberCtrl.text.trim()).then((flat) {
          _floorNumberCtrl.text = flat.floor.toString();
          _blockCtrl.text = flat.wing ?? '';
          _superBuiltUpAreaCtrl.text = flat.buitlUpArea ?? '';
          _carpetAreaCtrl.text = flat.carpetArea ?? '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    _auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Add Society Member'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
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
          icon: Icons.call_outlined,
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
          height: defaultPadding * 2,
        ),
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
                keyboardType: TextInputType.name,
                obscure: false,
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
          icon: Icons.home_outlined,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () async {
            if (_nameCtrl.text.isEmpty ||
                _emailCtrl.text.isEmpty ||
                _phoneCtrl.text.isEmpty ||
                _flatNumberCtrl.text.isEmpty ||
                _floorNumberCtrl.text.isEmpty ||
                _superBuiltUpAreaCtrl.text.isEmpty ||
                _carpetAreaCtrl.text.isEmpty) {
              SnackBarService.instance
                  .showSnackBarError('All fields are mandatory');
              return;
            }
            UserProfile newUser = UserProfile(
              userName: _nameCtrl.text,
              relationship: userDefaultRelationship,
              email: _emailCtrl.text,
              roles: memberRole,
              dob: '',
              gender: _gender,
              imagePath: '',
              mobileNo: _phoneCtrl.text,
              flats: FlatModel(
                buitlUpArea: _superBuiltUpAreaCtrl.text,
                carpetArea: _carpetAreaCtrl.text,
                flatNo: _flatNumberCtrl.text,
                floor: int.parse(_floorNumberCtrl.text),
                tower: _blockCtrl.text,
                wing: _blockCtrl.text,
              ),
            );
            await _auth
                .registerUserWithEmailAndPassword(newUser, _phoneCtrl.text)
                .then((value) {
              if (_auth.status == AuthStatus.authenticated && value) {
                Navigator.of(context).pop();
              }
            });
          },
          label: _auth.status == AuthStatus.authenticating
              ? 'Please wait...'
              : 'Create',
          isDisabled: _auth.status == AuthStatus.authenticating,
        )
      ],
    );
  }
}
