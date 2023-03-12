import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxsociety/model/vehicle_model.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/constants.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/button_active.dart';
import 'package:maxsociety/widget/custom_textfield.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../service/storage_service.dart';
import '../../util/enums.dart';
import '../../util/helper_methods.dart';
import '../../util/preference_key.dart';

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

  bool isImageSelected = false;
  bool isImageUploading = false;

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
          'Add vehicle image (Optional)',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 200,
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
                    child: const Text('Select image'),
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
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () async {
            if (_brandCtrl.text.isEmpty ||
                _modelCtrl.text.isEmpty ||
                _regNoCtrl.text.isEmpty) {
              SnackBarService.instance
                  .showSnackBarError('All fields are mandatory');
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
                StorageFolders.vehicle.name,
              );
               setState(() {
                isImageUploading = false;
              });
            }
            VehicleModel newVehicle = VehicleModel(
                brand: _brandCtrl.text,
                model: _modelCtrl.text,
                vehicleNo: _regNoCtrl.text,
                vehicleType: _vehicleType,
                flats: userProfile.flats?.flatNo,
                image: imageUrl);

            await _api.addVehicle(newVehicle).then((value) {
              if (_api.status == ApiStatus.success && value) {
                Navigator.of(context).pop();
              }
            });
          },
          label: _api.status == ApiStatus.loading
              ? 'Please wait...'
              : 'Add Vehicle',
          isDisabled: _api.status == ApiStatus.loading|| isImageUploading,
        ),
      ],
    );
  }
}
