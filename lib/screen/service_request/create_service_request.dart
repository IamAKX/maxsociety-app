import 'package:flutter/material.dart';
import 'package:maxsociety/util/constants.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/custom_textfield.dart';
import 'package:maxsociety/widget/heading.dart';

import '../../util/colors.dart';
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
  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
  }

  @override
  Widget build(BuildContext context) {
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
          label: 'Create Request',
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
