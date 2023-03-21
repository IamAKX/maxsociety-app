import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

import 'package:maxsociety/model/flat_model.dart';
import 'package:maxsociety/service/snakbar_service.dart';
import 'package:maxsociety/widget/button_active.dart';
import 'package:provider/provider.dart';

import '../../service/api_service.dart';
import '../../util/constants.dart';
import '../../util/theme.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/heading.dart';

class UpdateFlat extends StatefulWidget {
  const UpdateFlat({
    Key? key,
    required this.flat,
  }) : super(key: key);
  static const String routePath = '/adminControls/flat/update';
  final FlatModel flat;
  @override
  State<UpdateFlat> createState() => _UpdateFlatState();
}

class _UpdateFlatState extends State<UpdateFlat> {
  final TextEditingController _builtUpCtrl = TextEditingController();
  final TextEditingController _carpetCtrl = TextEditingController();
  SnackBarService snackBarService = SnackBarService.instance;
  String _flatType = flatTypeList.first;

  late ApiProvider _api;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _builtUpCtrl.text = widget.flat.buitlUpArea ?? '';
    _carpetCtrl.text = widget.flat.carpetArea ?? '';
    _flatType = widget.flat.type ?? flatTypeList.first;
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Flat ${widget.flat.flatNo}'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        CustomTextField(
          hint: 'Builtup area in sqft',
          controller: _builtUpCtrl,
          keyboardType: TextInputType.number,
          obscure: false,
          icon: Icons.text_rotation_angledown_rounded,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        CustomTextField(
          hint: 'Carpet area in sqft',
          controller: _carpetCtrl,
          keyboardType: TextInputType.number,
          obscure: false,
          icon: Icons.text_rotation_angledown_rounded,
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Text(
          'Select Flat Type',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        SizedBox(
          height: 50.0,
          child: RadioGroup<String>.builder(
            direction: Axis.horizontal,
            groupValue: _flatType,
            horizontalAlignment: MainAxisAlignment.spaceAround,
            onChanged: (value) => setState(() {
              _flatType = value ?? '';
            }),
            items: flatTypeList,
            textStyle: Theme.of(context).textTheme.bodyLarge,
            itemBuilder: (item) => RadioButtonBuilder(
              item,
            ),
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Row(
          children: [
            Expanded(
              child: ActiveButton(
                onPressed: () async {
                  await _api.deleteFlat(widget.flat.flatNo ?? '').then((value) {
                    if (value) {
                      Navigator.of(context).pop();
                    }
                  });
                },
                label: 'Delete',
              ),
            ),
            const SizedBox(
              width: defaultPadding,
            ),
            Expanded(
              child: ActiveButton(
                onPressed: () async {
                  if (_builtUpCtrl.text.isEmpty || _carpetCtrl.text.isEmpty) {
                    SnackBarService.instance
                        .showSnackBarError('All fields are mandatory');
                    return;
                  }
                  widget.flat.buitlUpArea = _builtUpCtrl.text;
                  widget.flat.carpetArea = _carpetCtrl.text;
                  widget.flat.type = _flatType;
                  await _api.updateFlat(widget.flat).then((value) {
                    if (value) {
                      Navigator.of(context).pop();
                    }
                  });
                },
                label: 'Update',
              ),
            ),
          ],
        )
      ],
    );
  }
}
