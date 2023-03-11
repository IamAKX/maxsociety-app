import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/constants.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/util/datetime_formatter.dart';
import 'package:maxsociety/widget/custom_textfield.dart';
import 'package:maxsociety/widget/heading.dart';

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
                Icons.calendar_month_outlined,
                color: Colors.grey,
              ),
              const SizedBox(
                width: defaultPadding / 2,
              ),
              InkWell(
                onTap: () => _selectDate(context),
                child: (_dateOfBirth == null)
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
              ),
            ],
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
            child: const Text('Select image'),
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () {},
          label: 'Add Family Member',
        ),
      ],
    );
  }
}
