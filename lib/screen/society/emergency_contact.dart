import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maxsociety/model/emergency_contact_model.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/theme.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({super.key});
  static const String routePath = '/emergencyContact';

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  late ApiProvider _api;
  List<EmergencyContactModel> contactList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadContacts(),
    );
  }

  loadContacts() async {
    await _api.getEmergencyContacts().then((value) {
      setState(() {
        contactList = value.data ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Emergency Contacts'),
      ),
      body: getBody(context),
      backgroundColor: backgroundDark,
    );
  }

  getBody(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(defaultPadding),
      itemCount: contactList.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: background,
                border: Border.all(
                  color: dividerColor,
                ),
                borderRadius: BorderRadius.circular(defaultPadding / 4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        getIconByCategory(
                            contactList.elementAt(index).category ?? ''),
                        size: getIconSizedByCategory(
                            contactList.elementAt(index).category ?? ''),
                        color: textColorDark,
                      ),
                      const SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Text(
                        contactList.elementAt(index).category ?? '',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          createAddContactPopup(
                              contactList.elementAt(index), context);
                        },
                        icon: const Icon(Icons.add),
                      )
                    ],
                  ),
                  for (String ph
                      in contactList.elementAt(index).phoneNumbers ?? []) ...{
                    phoneNumberRow(
                        context, ph, contactList.elementAt(index).id!),
                  }
                ],
              ),
            ),
            const SizedBox(
              height: defaultPadding * 1.5,
            ),
          ],
        );
      },
    );
  }

  Row phoneNumberRow(BuildContext context, String phoneNumber, int id) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          phoneNumber,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const Spacer(),
        IconButton(
          onPressed: () async {
            await _api.deleteEmergencyContact(id, phoneNumber).then(
                  (value) => loadContacts(),
                );
          },
          icon: const Icon(
            Icons.delete_forever,
            color: Colors.red,
          ),
        ),
        IconButton(
          onPressed: () {
            launchUrl(Uri.parse('tel:$phoneNumber'));
          },
          icon: const Icon(
            Icons.call,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  createAddContactPopup(EmergencyContactModel contact, BuildContext context) {
    final TextEditingController phoneCtrl = TextEditingController();

    Widget okButton = TextButton(
      child: const Text("Add"),
      onPressed: () async {
        Navigator.of(context).pop();
        if (phoneCtrl.text.isEmpty) {
          SnackBarService.instance.showSnackBarError('Enter phone number');
          return;
        }

        List<String> phoneList = contact.phoneNumbers ?? [];
        phoneList.add(phoneCtrl.text);
        await _api
            .createEmergencyContact(contact.category ?? '', phoneList)
            .then((value) => loadContacts());
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text('Add ${contact.category} Contact'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: phoneCtrl,
            maxLines: 1,
            decoration: secondaryTextFieldDecoration('Phone number'),
          ),
        ],
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  IconData? getIconByCategory(String category) {
    switch (category) {
      case 'Police':
        return Icons.local_police_rounded;
      case 'Ambulance':
        return FontAwesomeIcons.truckMedical;
      case 'Fire Brigade':
        return Icons.fire_truck;
      case 'Hospital':
        return FontAwesomeIcons.solidHospital;
      default:
        return Icons.call;
    }
  }

  getIconSizedByCategory(String category) {
    switch (category) {
      case 'Police':
        return 22.0;
      case 'Ambulance':
        return 18.0;
      case 'Fire Brigade':
        return 22.0;
      case 'Hospital':
        return 18.0;
      default:
        return 22.0;
    }
  }
}
