import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/constants.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/button_active.dart';
import 'package:maxsociety/widget/custom_textfield.dart';
import 'package:maxsociety/widget/heading.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});
  static const String routePath = '/addVehicleScreen';

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final TextEditingController _brandCtrl = TextEditingController();
  final TextEditingController _modelCtrl = TextEditingController();
  final TextEditingController _regNoCtrl = TextEditingController();
  String _vehicleType = vehicleTypeList.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Add Vehicle'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        CustomTextField(
          hint: 'Brand name',
          controller: _brandCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.car_rental_outlined,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        CustomTextField(
          hint: 'Model name',
          controller: _modelCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.car_rental_outlined,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        CustomTextField(
          hint: 'Registration number',
          controller: _regNoCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.sort_by_alpha_rounded,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Text(
          'Select vehicle type',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        SizedBox(
          height: 50.0,
          child: RadioGroup<String>.builder(
            direction: Axis.horizontal,
            groupValue: _vehicleType,
            horizontalAlignment: MainAxisAlignment.spaceAround,
            onChanged: (value) => setState(() {
              _vehicleType = value ?? '';
            }),
            items: vehicleTypeList,
            textStyle: Theme.of(context).textTheme.bodyLarge,
            itemBuilder: (item) => RadioButtonBuilder(
              item,
            ),
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Text(
          'Add vehicle image',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(
              color: dividerColor,
            ),
          ),
          child: const Text('Select image'),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () {},
          label: 'Add Vehicle',
        ),
      ],
    );
  }
}
