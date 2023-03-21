import 'dart:developer';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../service/storage_service.dart';
import '../../util/colors.dart';
import '../../util/datetime_formatter.dart';
import '../../util/enums.dart';
import '../../util/helper_methods.dart';
import '../../util/preference_key.dart';
import '../../widget/button_active.dart';
import '../../widget/heading.dart';

class CreateRuleScreen extends StatefulWidget {
  const CreateRuleScreen({super.key});
  static const String routePath = '/societyRule/create';
  @override
  State<CreateRuleScreen> createState() => _CreateRuleScreenState();
}

class _CreateRuleScreenState extends State<CreateRuleScreen> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  String effectiveDate = '';
  late ApiProvider _api;
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);

  bool isImageSelected = false;
  bool isImageUploading = false;
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Create Rule'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          'Rule Title',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        TextField(
          controller: _titleCtrl,
          maxLines: 3,
          decoration: secondaryTextFieldDecoration('Title'),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Text(
          'Rule Detail',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        TextField(
          controller: _descCtrl,
          maxLines: 10,
          decoration: secondaryTextFieldDecoration('Detail'),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Text(
          'Effective from',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        DateTimePicker(
          type: DateTimePickerType.date,
          initialValue: '',
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 1),
          dateHintText: 'Date',
          timeHintText: 'Time',
          dateMask: 'd MMM, yyyy',
          calendarTitle: 'Schedule event',
          onChanged: (val) => effectiveDate = val,
          validator: (val) {
            return null;
          },
          onSaved: (val) => effectiveDate = val!,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(defaultPadding / 2),
              borderSide: const BorderSide(
                color: primaryColor,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(defaultPadding / 2),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Add Attachment (Optinal)',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            isImageSelected
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        imageFile = null;
                        isImageSelected = false;
                      });
                    },
                    child: Text(
                      'Delete',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.red,
                          ),
                    ),
                  )
                : TextButton(
                    onPressed: () async {
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
                    child: const Text('Add'),
                  )
          ],
        ),
        Visibility(
          visible: isImageSelected,
          child: Text(getFileName(imageFile)),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () async {
            if (_titleCtrl.text.isEmpty || _descCtrl.text.isEmpty) {
              SnackBarService.instance
                  .showSnackBarError('Title or Detail cannot be empty');
              return;
            }
            try {
              log(effectiveDate);
              effectiveDate =
                  formatFromDatepickerToDatabaseOnlyDate(effectiveDate);
            } catch (e) {
              SnackBarService.instance.showSnackBarError('Pick effective date');
              return;
            }
            if (effectiveDate.isEmpty) {
              SnackBarService.instance
                  .showSnackBarError('Select effective date');
              return;
            }

            String imageUrl = '';
            if (imageFile != null) {
              SnackBarService.instance
                  .showSnackBarInfo('Uploading file, please wait');
              setState(() {
                isImageUploading = true;
              });
              imageUrl = await StorageService.uploadEventImage(
                imageFile!,
                getFileName(imageFile),
                StorageFolders.rule.name,
              );
              setState(() {
                isImageUploading = false;
              });
            }
            var createCircularReqBody = {
              'subject': _titleCtrl.text,
              'circularText': _descCtrl.text,
              'fileType': '',
              'createdBy': {'userId': userProfile.userId},
              'createdOn': formatToServerTimestamp(DateTime.now()),
              'updatedBy': {'userId': userProfile.userId},
              'updatedOn': formatToServerTimestamp(DateTime.now()),
              'circularType': CircularType.SOCIETY_RULE.name,
              'circularStatus': CircularStatus.OPEN.name,
              'circularCategory': '',
              'circularImages': imageUrl.trim().isEmpty ? [] : [imageUrl],
              'eventDate': effectiveDate,
              'showEventDate': true,
            };
            _api.createCircular(createCircularReqBody).then((value) {
              if (value) {
                Navigator.of(context).pop();
              }
            });
          },
          label: _api.status == ApiStatus.loading || isImageUploading
              ? 'Please wait...'
              : 'Create',
          isDisabled: _api.status == ApiStatus.loading || isImageUploading,
        )
      ],
    );
  }
}
