import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxsociety/util/constants.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/custom_textfield.dart';
import 'package:maxsociety/widget/heading.dart';
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

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({super.key, required this.category});
  final String category;
  static const String routePath = '/createServiceScreen';

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  late String _selectedCategory;
  bool isImageSelected = false;
  bool isImageUploading = false;

  File? imageFile;

  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  late ApiProvider _api;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'New Request'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          'Title',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        TextField(
          controller: _titleCtrl,
          maxLines: 1,
          decoration: textFieldDecoration('Title'),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        TextField(
          controller: _descCtrl,
          maxLines: 5,
          decoration: textFieldDecoration('Description'),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Container(
          padding: const EdgeInsets.all(defaultPadding / 2),
          decoration: BoxDecoration(
            color: textFieldFillColor,
            borderRadius: BorderRadius.circular(defaultPadding / 2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              underline: null,
              isExpanded: true,
              items: serviceRequestCategories.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Text(
          'Add Image',
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
            height: 200,
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
                      height: 200,
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
                        height: 200,
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
            if (_titleCtrl.text.isEmpty || _descCtrl.text.isEmpty) {
              SnackBarService.instance
                  .showSnackBarError('Enter title and description');
              return;
            }
            if (imageFile == null) {
              SnackBarService.instance
                  .showSnackBarError('Select an image of your issue');
              return;
            }
            String imageUrl = '';
            SnackBarService.instance
                .showSnackBarInfo('Uploading file, please wait');
            setState(() {
              isImageUploading = true;
            });
            imageUrl = await StorageService.uploadEventImage(
              imageFile!,
              getFileName(imageFile),
              StorageFolders.serviceRequest.name,
            );
            setState(() {
              isImageUploading = false;
            });
            var createCircularReqBody = {
              'subject': _titleCtrl.text,
              'circularText': _descCtrl.text,
              'fileType': getFileExtension(imageFile),
              'createdBy': {'userId': userProfile.userId},
              'createdOn': formatToServerTimestamp(DateTime.now()),
              'updatedBy': {'userId': userProfile.userId},
              'updatedOn': formatToServerTimestamp(DateTime.now()),
              'circularType': CircularType.SERVICE_REQUEST.name,
              'circularStatus': CircularStatus.OPEN.name,
              'circularCategory': _selectedCategory,
              'circularImages': imageUrl.trim().isEmpty ? [] : [imageUrl],
              'eventDate': formatToServerTimestamp(DateTime.now()),
              'showEventDate': true
            };
            _api.createCircular(createCircularReqBody).then((value) {
              if (value) {
                Navigator.of(context).pop();
              }
            });
          },
          label: _api.status == ApiStatus.loading
              ? 'Please wait...'
              : 'Create Request',
          isDisabled: _api.status == ApiStatus.loading || isImageUploading,
        ),
      ],
    );
  }

  InputDecoration textFieldDecoration(String hint) {
    return InputDecoration(
      alignLabelWithHint: false,
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultPadding / 2),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1,
        ),
      ),
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultPadding / 2),
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
    );
  }
}
