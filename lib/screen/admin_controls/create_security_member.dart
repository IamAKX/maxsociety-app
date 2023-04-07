import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:maxsociety/widget/button_active.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/auth_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/constants.dart';
import '../../util/preference_key.dart';
import '../../util/theme.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/heading.dart';

class CreateSecurityMember extends StatefulWidget {
  const CreateSecurityMember({super.key});
  static const String routePath = '/adminControls/securityMember/create';

  @override
  State<CreateSecurityMember> createState() => _CreateSecurityMemberState();
}

class _CreateSecurityMemberState extends State<CreateSecurityMember> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  // final TextEditingController _flatNumberCtrl = TextEditingController();
  // final TextEditingController _floorNumberCtrl = TextEditingController();
  // final TextEditingController _blockCtrl = TextEditingController();
  // final TextEditingController _carpetAreaCtrl = TextEditingController();
  // final TextEditingController _superBuiltUpAreaCtrl = TextEditingController();
  String _gender = genderList.first;
  String _designation = 'Guard';
  String _category = 'General';
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  late ApiProvider _api;
  late AuthProvider _auth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _flatNumberCtrl.addListener(() async {
      //   if (_flatNumberCtrl.text.length > 3) {
      //     await _api.getFlatByFlatNo(_flatNumberCtrl.text.trim()).then((flat) {
      //       _floorNumberCtrl.text = flat.floor.toString();
      //       _blockCtrl.text = flat.wing ?? '';
      //       _superBuiltUpAreaCtrl.text = flat.buitlUpArea ?? '';
      //       _carpetAreaCtrl.text = flat.carpetArea ?? '';
      //     });
      //   }
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    _auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Heading(
          title: 'Add Security Member',
          overrideFontSize: 25,
        ),
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
          height: defaultPadding * 2,
        ),
        // Text(
        //   'JOB ROLE',
        //   style: Theme.of(context).textTheme.labelMedium?.copyWith(
        //         fontWeight: FontWeight.bold,
        //       ),
        // ),
        // const SizedBox(
        //   height: defaultPadding / 2,
        // ),
        // Container(
        //   padding: const EdgeInsets.all(defaultPadding / 2),
        //   height: 60,
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     color: textFieldFillColor,
        //     borderRadius: BorderRadius.circular(defaultPadding * 3),
        //   ),
        //   child: Row(
        //     children: [
        //       const Icon(
        //         Icons.workspace_premium_outlined,
        //         color: Colors.grey,
        //       ),
        //       const SizedBox(
        //         width: defaultPadding / 2,
        //       ),
        //       Expanded(
        //         child: DropdownButtonHideUnderline(
        //           child: DropdownButton<String>(
        //             value: _designation,
        //             underline: null,
        //             isExpanded: true,
        //             items: committeeMemberDesignationList.map((String value) {
        //               return DropdownMenuItem<String>(
        //                 value: value,
        //                 child: Text(value),
        //               );
        //             }).toList(),
        //             onChanged: (value) {
        //               setState(() {
        //                 _designation = value!;
        //               });
        //             },
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(
        //   height: defaultPadding / 2,
        // ),
        // Container(
        //   padding: const EdgeInsets.all(defaultPadding / 2),
        //   height: 60,
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     color: textFieldFillColor,
        //     borderRadius: BorderRadius.circular(defaultPadding * 3),
        //   ),
        //   child: Row(
        //     children: [
        //       const Icon(
        //         Icons.category_outlined,
        //         color: Colors.grey,
        //       ),
        //       const SizedBox(
        //         width: defaultPadding / 2,
        //       ),
        //       Expanded(
        //         child: DropdownButtonHideUnderline(
        //           child: DropdownButton<String>(
        //             value: _category,
        //             underline: null,
        //             isExpanded: true,
        //             items: committeeMemberCategoryList.map((String value) {
        //               return DropdownMenuItem<String>(
        //                 value: value,
        //                 child: Text(value),
        //               );
        //             }).toList(),
        //             onChanged: (value) {
        //               setState(() {
        //                 _category = value!;
        //               });
        //             },
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(
        //   height: defaultPadding * 2,
        // ),
        // Text(
        //   'FLAT DETAILS',
        //   style: Theme.of(context).textTheme.labelMedium?.copyWith(
        //         fontWeight: FontWeight.bold,
        //       ),
        // ),
        // const SizedBox(
        //   height: defaultPadding / 2,
        // ),
        // Row(
        //   children: [
        //     Expanded(
        //       child: CustomTextField(
        //         hint: 'Flat',
        //         controller: _flatNumberCtrl,
        //         keyboardType: TextInputType.name,
        //         obscure: false,
        //         icon: Icons.home_outlined,
        //       ),
        //     ),
        //     const SizedBox(
        //       width: defaultPadding / 2,
        //     ),
        //     Expanded(
        //       child: CustomTextField(
        //         hint: 'Floor',
        //         controller: _floorNumberCtrl,
        //         keyboardType: TextInputType.number,
        //         obscure: false,
        //         icon: Icons.home_outlined,
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(
        //   height: defaultPadding / 2,
        // ),
        // CustomTextField(
        //   hint: 'Block or Wing',
        //   controller: _blockCtrl,
        //   keyboardType: TextInputType.name,
        //   obscure: false,
        //   icon: Icons.home_outlined,
        // ),
        // const SizedBox(
        //   height: defaultPadding / 2,
        // ),
        // CustomTextField(
        //   hint: 'Super built-up area in sqft',
        //   controller: _superBuiltUpAreaCtrl,
        //   keyboardType: TextInputType.number,
        //   obscure: false,
        //   icon: Icons.home_outlined,
        // ),
        // const SizedBox(
        //   height: defaultPadding / 2,
        // ),
        // CustomTextField(
        //   hint: 'Carpet area in sqft',
        //   controller: _carpetAreaCtrl,
        //   keyboardType: TextInputType.number,
        //   obscure: false,
        //   icon: Icons.home_outlined,
        // ),
        // const SizedBox(
        //   height: defaultPadding,
        // ),
        ActiveButton(
          onPressed: () async {
            if (_nameCtrl.text.isEmpty ||
                _emailCtrl.text.isEmpty ||
                _phoneCtrl.text.isEmpty) {
              SnackBarService.instance
                  .showSnackBarError('All fields are mandatory');
              return;
            }
            UserProfile newUser = UserProfile(
              userName: _nameCtrl.text,
              relationship: userDefaultRelationship,
              email: _emailCtrl.text,
              roles: guardRole,
              dob: '',
              gender: _gender,
              imagePath: '',
              mobileNo: _phoneCtrl.text,
              category: _category,
              designation: _designation,
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
