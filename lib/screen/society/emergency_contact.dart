import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maxsociety/widget/custom_textfield.dart';
import 'package:maxsociety/widget/heading.dart';

import '../../util/colors.dart';
import '../../util/theme.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({super.key});
  static const String routePath = '/emergencyContact';

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Emergency Contacts'),
      ),
      body: getBody(context),
      backgroundColor: backgroundDark,
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
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
                  const Icon(
                    Icons.local_police_rounded,
                    size: 22,
                    color: textColorDark,
                  ),
                  const SizedBox(
                    width: defaultPadding / 2,
                  ),
                  Text(
                    'Police',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      createAddContactPopup('Police', context);
                    },
                    icon: const Icon(Icons.add),
                  )
                ],
              ),
              phoneNumberRow(context, '100'),
              phoneNumberRow(context, '+91 9804321744'),
              phoneNumberRow(context, '+91 7763926677'),
            ],
          ),
        ),
        const SizedBox(
          height: defaultPadding * 1.5,
        ),
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
                  const Icon(
                    FontAwesomeIcons.truckMedical,
                    size: 18,
                    color: textColorDark,
                  ),
                  const SizedBox(
                    width: defaultPadding / 2,
                  ),
                  Text(
                    'Ambulance',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      createAddContactPopup('Ambulance', context);
                    },
                    icon: const Icon(Icons.add),
                  )
                ],
              ),
              phoneNumberRow(context, '101'),
              phoneNumberRow(context, '+91 9804321744'),
            ],
          ),
        ),
        const SizedBox(
          height: defaultPadding * 1.5,
        ),
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
                  const Icon(
                    FontAwesomeIcons.solidHospital,
                    size: 18,
                    color: textColorDark,
                  ),
                  const SizedBox(
                    width: defaultPadding / 2,
                  ),
                  Text(
                    'Hospital',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      createAddContactPopup('Hospital', context);
                    },
                    icon: const Icon(Icons.add),
                  )
                ],
              ),
              phoneNumberRow(context, '+91 9804321744'),
              phoneNumberRow(context, '+91 9801122334'),
            ],
          ),
        ),
        const SizedBox(
          height: defaultPadding * 1.5,
        ),
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
                  const Icon(
                    Icons.fire_truck,
                    size: 25,
                    color: textColorDark,
                  ),
                  const SizedBox(
                    width: defaultPadding / 2,
                  ),
                  Text(
                    'Fire Brigade',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      createAddContactPopup('Fire Brigade', context);
                    },
                    icon: const Icon(Icons.add),
                  )
                ],
              ),
              phoneNumberRow(context, '101'),
              phoneNumberRow(context, '+91 9804321744'),
            ],
          ),
        ),
      ],
    );
  }

  Row phoneNumberRow(BuildContext context, String phoneNumber) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          phoneNumber,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.delete_forever,
            color: Colors.red,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.call,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  createAddContactPopup(String title, BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("Add"),
      onPressed: () {},
    );
    final TextEditingController phoneCtrl = TextEditingController();

    AlertDialog alert = AlertDialog(
      title: Text('Add $title Contact'),
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
}
