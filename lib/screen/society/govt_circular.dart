import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maxsociety/service/snakbar_service.dart';
import 'package:maxsociety/widget/custom_textfield.dart';
import 'package:maxsociety/widget/pdf_viewer.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/circular_model.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/storage_service.dart';
import '../../util/colors.dart';
import '../../util/datetime_formatter.dart';
import '../../util/enums.dart';
import '../../util/helper_methods.dart';
import '../../util/preference_key.dart';
import '../../widget/heading.dart';

class GovermentCircularScreen extends StatefulWidget {
  const GovermentCircularScreen({super.key});
  static const String routePath = '/govermentCircularScreen';

  get meetingId => null;
  @override
  State<GovermentCircularScreen> createState() =>
      _GovermentCircularScreenState();
}

class _GovermentCircularScreenState extends State<GovermentCircularScreen> {
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  late ApiProvider _api;
  List<CircularModel> circularList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadCirculars(),
    );
  }

  loadCirculars() async {
    _api
        .getCircularsByCircularType(CircularType.GOVT_CIRCULAR.name)
        .then((value) {
      setState(() {
        circularList = value.data ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Govt. Circular'),
        actions: [
          if (isAdminUser())
            TextButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );

                if (result != null) {
                  File file = File(result.files.single.path!);
                  showFileUploadPopup(file, context);
                } else {
                  // User canceled the picker
                }
              },
              child: const Text('Upload'),
            )
        ],
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    if (_api.status == ApiStatus.failed) {
      return Center(
        child: Text(
          'No Goverment Circular found',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(
              FontAwesomeIcons.solidFilePdf,
              color: primaryColor,
            ),
            title: Text(
              circularList.elementAt(index).subject ?? '',
              maxLines: 2,
            ),
            subtitle: Text(
              'Uploaded on ${eventDateToDate(circularList.elementAt(index).eventDate ?? '')}',
              maxLines: 2,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).pushNamed(PDFViewer.routePath,
                  arguments: circularList
                      .elementAt(index)
                      .circularImages
                      ?.first
                      .imageUrl);
            },
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: dividerColor,
          );
        },
        itemCount: circularList.length);
  }

  void showFileUploadPopup(File file, BuildContext context) {
    TextEditingController _nameCtrl = TextEditingController();
    AlertDialog alert = AlertDialog(
      title: const Text("Enter circular name"),
      content: CustomTextField(
          hint: 'Circular name',
          controller: _nameCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.file_copy_outlined),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_nameCtrl.text.isEmpty) {
              SnackBarService.instance.showSnackBarInfo('Enter circular name');
              return;
            }
            Navigator.of(context).pop();
            String imageUrl = '';

            SnackBarService.instance
                .showSnackBarInfo('Uploading file, please wait');
            imageUrl = await StorageService.uploadEventImage(
              file,
              getFileName(file),
              StorageFolders.govtCircular.name,
            );
            var createCircularReqBody = {
              'subject': _nameCtrl.text,
              'circularText': '',
              'fileType': getFileExtension(file),
              'createdBy': {'userId': userProfile.userId},
              'createdOn': formatToServerTimestamp(DateTime.now()),
              'updatedBy': {'userId': userProfile.userId},
              'updatedOn': formatToServerTimestamp(DateTime.now()),
              'circularType': CircularType.GOVT_CIRCULAR.name,
              'circularStatus': CircularStatus.OPEN.name,
              'circularCategory': '',
              'circularImages': imageUrl.trim().isEmpty ? [] : [imageUrl],
              'eventDate': formatToServerTimestamp(DateTime.now()),
              'showEventDate': true,
            };
            _api.createCircular(createCircularReqBody).then((value) {
              if (value) {
                loadCirculars();
              }
            });
          },
          child: const Text('Upload'),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
