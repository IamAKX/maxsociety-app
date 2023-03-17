import 'dart:developer';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxsociety/model/circular_model.dart';
import 'package:maxsociety/service/api_service.dart';
import 'package:maxsociety/service/snakbar_service.dart';
import 'package:maxsociety/service/storage_service.dart';
import 'package:maxsociety/util/datetime_formatter.dart';
import 'package:maxsociety/util/helper_methods.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/button_active.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/user_profile_model.dart';
import '../../util/colors.dart';
import '../../util/enums.dart';
import '../../util/preference_key.dart';
import '../../widget/heading.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});
  static const String routePath = '/events/create';

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController _descCtrl = TextEditingController();
  bool showDateOnPost = false;
  bool isImageSelected = false;
  bool isImageUploading = false;

  File? imageFile;
  String eventDate = '';
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  late ApiProvider _api;

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Create Event'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          'Event detail',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        TextField(
          controller: _descCtrl,
          maxLines: 7,
          decoration: secondaryTextFieldDecoration('Details'),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Text(
          'Add Image (Optional)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: double.infinity,
            height: 150,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: dividerColor,
              ),
            ),
            child: !isImageSelected
                ? InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 150,
                      child: const Text(
                        'Select image',
                        textAlign: TextAlign.center,
                      ),
                    ),
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
          height: defaultPadding / 2,
        ),
        Text(
          'Event date (Optional)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Show event schedule date and time on feed',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(),
            ),
            Checkbox(
              value: showDateOnPost,
              onChanged: (value) {
                setState(() {
                  showDateOnPost = value ?? false;
                });
              },
            )
          ],
        ),
        DateTimePicker(
          type: DateTimePickerType.dateTimeSeparate,
          initialValue: '',
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 1),
          dateHintText: 'Date',
          timeHintText: 'Time',
          dateMask: 'd MMM, yyyy',
          calendarTitle: 'Schedule event',
          onChanged: (val) {
            eventDate = val;
            log('onchange : $eventDate');
          },
          validator: (val) {
            return null;
          },
          onSaved: (newValue) {
            eventDate = newValue!;
            log('onchange : $eventDate');
          },
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
        ActiveButton(
          onPressed: () async {
            if (_descCtrl.text.isEmpty) {
              SnackBarService.instance.showSnackBarError('Enter event details');
              return;
            }

            try {
              log(eventDate);
              eventDate = formatFromDatepickerToDatabase(eventDate);
            } catch (e) {
              SnackBarService.instance
                  .showSnackBarError('Enter date and time of the event');
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
                StorageFolders.events.name,
              );
              setState(() {
                isImageUploading = false;
              });
            }
            var createCircularReqBody = {
              'subject': '',
              'circularText': _descCtrl.text,
              'fileType': getFileExtension(imageFile),
              'createdBy': {'userId': userProfile.userId},
              'createdOn': formatToServerTimestamp(DateTime.now()),
              'updatedBy': {'userId': userProfile.userId},
              'updatedOn': formatToServerTimestamp(DateTime.now()),
              'circularType': CircularType.CIRCULAR.name,
              'circularStatus': CircularStatus.OPEN.name,
              'circularCategory': '',
              'circularImages': imageUrl.trim().isEmpty ? [] : [imageUrl],
              'eventDate': eventDate,
              'showEventDate': showDateOnPost
            };
            _api.createCircular(createCircularReqBody).then((value) {
              if (value) {
                // setState(() {
                //   imageFile = null;
                //   isImageSelected = false;
                //   _descCtrl.text = '';
                //   eventDate = '';
                // });
                Navigator.of(context).pop();
              }
            });
          },
          label: _api.status == ApiStatus.loading ? 'Please wait...' : 'Create',
          isDisabled: _api.status == ApiStatus.loading || isImageUploading,
        )
      ],
    );
  }
}
