import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxsociety/service/snakbar_service.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/constants.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/util/datetime_formatter.dart';
import 'package:maxsociety/widget/custom_textfield.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/storage_service.dart';
import '../../util/enums.dart';
import '../../util/helper_methods.dart';
import '../../util/preference_key.dart';
import '../../widget/button_active.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({super.key});
  static const String routePath = '/addFamilyScreen';

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();
  DateTime? _dateOfBirth;
  String _gender = genderList.first;
  String _relationship = relationshipList.first;
  bool isImageSelected = false;
  File? imageFile;
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  late ApiProvider _api;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Add Family Member'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
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
          hint: 'Phone',
          controller: _mobileCtrl,
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
          height: defaultPadding / 2,
        ),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: textFieldFillColor,
              borderRadius: BorderRadius.circular(defaultPadding * 3),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: defaultPadding / 2,
                ),
                (_dateOfBirth == null)
                    ? Text(
                        'Date of Birth',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.grey[700]),
                      )
                    : Text(
                        '${formatDateOfBirth(_dateOfBirth!)}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.grey[700]),
                      ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Container(
          padding: const EdgeInsets.all(defaultPadding / 2),
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: textFieldFillColor,
            borderRadius: BorderRadius.circular(defaultPadding * 3),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.male_outlined,
                color: Colors.grey,
              ),
              const SizedBox(
                width: defaultPadding / 2,
              ),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _relationship,
                    underline: null,
                    isExpanded: true,
                    items: relationshipList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _relationship = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Text(
          'Add profile image',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 150,
            height: 150,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: dividerColor,
              ),
            ),
            child: !isImageSelected
                ? InkWell(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        imageFile = File(image.path);

                        setState(() {
                          isImageSelected = true;
                        });
                      }
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      alignment: Alignment.center,
                      child: const Text('Select image'),
                    ),
                  )
                : Stack(
                    children: [
                      Image.file(
                        imageFile!,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.fitWidth,
                      ),
                      Positioned(
                        right: 1,
                        top: 1,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                imageFile = null;
                                isImageSelected = false;
                              });
                            },
                            icon: const Icon(
                              FontAwesomeIcons.trash,
                              color: Colors.red,
                            )),
                      )
                    ],
                  ),
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () async {
            if (_nameCtrl.text.isEmpty ||
                _mobileCtrl.text.isEmpty ||
                _dateOfBirth == null) {
              SnackBarService.instance
                  .showSnackBarError('All field are mandatory');
              return;
            }

            String imageUrl = '';
            if (imageFile != null) {
              SnackBarService.instance
                  .showSnackBarInfo('Uploading file, please wait');
              imageUrl = await StorageService.uploadEventImage(
                imageFile!,
                getFileName(imageFile),
                StorageFolders.profileImage.name,
              );
            }
            UserProfile newUser = UserProfile(
              userId:
                  'FM_${userProfile.userId}_${Random().nextInt(900000) + 100000}',
              userName: _nameCtrl.text,
              relationship: _relationship,
              email: userProfile.email,
              roles: memberRole,
              dob: formatToServerTimestamp(_dateOfBirth!),
              gender: _gender,
              imagePath: imageUrl,
              mobileNo: _mobileCtrl.text,
              flats: userProfile.flats,
            );

            await _api.createUser(newUser).then((value) {
              if (_api.status == ApiStatus.success && value) {
                SnackBarService.instance
                    .showSnackBarSuccess('Family member added');
                Navigator.of(context).pop();
              }
            });
          },
          label: _api.status == ApiStatus.loading
              ? 'Please wait...'
              : 'Add Family Member',
          isDisabled: _api.status == ApiStatus.loading,
        ),
      ],
    );
  }
}
