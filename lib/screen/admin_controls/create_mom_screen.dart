import 'dart:developer';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxsociety/util/helper_methods.dart';
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
import '../../util/preference_key.dart';
import '../../widget/button_active.dart';
import '../../widget/heading.dart';

class CreateMomScreen extends StatefulWidget {
  const CreateMomScreen({super.key});
  static const String routePath = '/mom/create';
  @override
  State<CreateMomScreen> createState() => _CreateMomScreenState();
}

class _CreateMomScreenState extends State<CreateMomScreen> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  String meetingDate = '';
  bool isImageSelected = false;
  File? imageFile;
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  late ApiProvider _api;

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Create MOM'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          'MOM Title',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        TextField(
          controller: _titleCtrl,
          maxLines: 2,
          decoration: secondaryTextFieldDecoration('Title'),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Text(
          'MOM Detail',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        TextField(
          controller: _descCtrl,
          maxLines: 8,
          decoration: secondaryTextFieldDecoration('Detail'),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Text(
          'Meeting date',
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
          onChanged: (val) => meetingDate = val,
          validator: (val) {
            return null;
          },
          onSaved: (val) => meetingDate = val!,
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
              log(meetingDate);
              meetingDate = formatFromDatepickerToDatabaseOnlyDate(meetingDate);
            } catch (e) {
              SnackBarService.instance
                  .showSnackBarError('Enter date and time of the event');
              return;
            }
            String imageUrl = '';
            if (imageFile != null) {
              SnackBarService.instance
                  .showSnackBarInfo('Uploading file, please wait');
              imageUrl = await StorageService.uploadEventImage(
                imageFile!,
                getFileName(imageFile),
                StorageFolders.mom.name,
              );
            }
            var createCircularReqBody = {
              'subject': _titleCtrl.text,
              'circularText': _descCtrl.text,
              'fileType': getFileExtension(imageFile),
              'createdBy': {'userId': userProfile.userId},
              'createdOn': formatToServerTimestamp(DateTime.now()),
              'updatedBy': {'userId': userProfile.userId},
              'updatedOn': formatToServerTimestamp(DateTime.now()),
              'circularType': CircularType.MOM.name,
              'circularStatus': CircularStatus.OPEN.name,
              'circularCategory': '',
              'circularImages': imageUrl.trim().isEmpty ? [] : [imageUrl],
              'eventDate': meetingDate,
              'showEventDate': true,
            };
            _api.createCircular(createCircularReqBody).then((value) {
              if (value) {
                Navigator.of(context).pop();
              }
            });
          },
          label: _api.status == ApiStatus.loading ? 'Please wait...' : 'Create',
          isDisabled: _api.status == ApiStatus.loading,
        )
      ],
    );
  }
}
