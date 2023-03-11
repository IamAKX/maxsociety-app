import 'package:flutter/material.dart';
import 'package:maxsociety/main.dart';
import 'package:maxsociety/model/flat_model.dart';
import 'package:maxsociety/screen/admin_controls/flat_summary.dart';
import 'package:maxsociety/service/snakbar_service.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/constants.dart';
import 'package:maxsociety/widget/button_active.dart';

import '../../util/theme.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/heading.dart';

class CreateFlat extends StatefulWidget {
  const CreateFlat({super.key});
  static const String routePath = '/adminControls/flat/create';
  @override
  State<CreateFlat> createState() => _CreateFlatState();
}

class _CreateFlatState extends State<CreateFlat> {
  final TextEditingController _floorCtrl = TextEditingController();
  final TextEditingController _flatsInFloorCtrl = TextEditingController();
  final TextEditingController _startWingCtrl = TextEditingController();
  final TextEditingController _endWingCtrl = TextEditingController();
  final TextEditingController _builtUpCtrl = TextEditingController();
  final TextEditingController _carpetCtrl = TextEditingController();
  int selectedFormat = 0;
  SnackBarService snackBarService = SnackBarService.instance;
  @override
  Widget build(BuildContext context) {
    snackBarService.buildContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Create Flat'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hint: 'Floor / Tower',
                controller: _floorCtrl,
                keyboardType: TextInputType.number,
                obscure: false,
                icon: Icons.numbers_outlined,
              ),
            ),
            const SizedBox(
              width: defaultPadding / 2,
            ),
            Expanded(
              child: CustomTextField(
                hint: 'Flat / Floor',
                controller: _flatsInFloorCtrl,
                keyboardType: TextInputType.number,
                obscure: false,
                icon: Icons.numbers_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hint: 'Start wing',
                controller: _startWingCtrl,
                keyboardType: TextInputType.text,
                obscure: false,
                icon: Icons.abc_rounded,
              ),
            ),
            const SizedBox(
              width: defaultPadding / 2,
            ),
            Expanded(
              child: CustomTextField(
                hint: 'End Wing',
                controller: _endWingCtrl,
                keyboardType: TextInputType.text,
                obscure: false,
                icon: Icons.abc_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
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
          'Select format',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedFormat = 2;
                  });
                },
                child: flatFormat1Card(),
              ),
            ),
            const SizedBox(
              width: defaultPadding / 2,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedFormat = 3;
                  });
                },
                child: flatFormat2Card(),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ActiveButton(
          onPressed: () {
            try {
              List<FlatModel> flatList = [];
              for (var ch = _startWingCtrl.text.codeUnits[0];
                  ch <= _endWingCtrl.text.codeUnits[0];
                  ch++) {
                for (var i = 1; i <= int.parse(_floorCtrl.text); i++) {
                  for (var j = 1; j <= int.parse(_flatsInFloorCtrl.text); j++) {
                    flatList.add(
                      FlatModel(
                        wing: String.fromCharCode(ch),
                        tower: String.fromCharCode(ch),
                        floor: i,
                        flatNo:
                            '$i${j.toString().padLeft(selectedFormat, '0')}',
                        buitlUpArea: _builtUpCtrl.text,
                        carpetArea: _carpetCtrl.text,
                      ),
                    );
                  }
                }
              }

              Navigator.of(context)
                  .pushNamed(FlatSummary.routePath, arguments: flatList);
            } catch (e) {
              snackBarService.showSnackBarError('Invalid input');
            }
          },
          label: 'Generate Sequence',
        )
      ],
    );
  }

  Card flatFormat1Card() {
    return Card(
      elevation: defaultPadding / 4,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedFormat == 2 ? primaryColor : Colors.transparent,
          ),
        ),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: flatFormat1.length,
          itemBuilder: (context, index) =>
              Center(child: Text(flatFormat1.elementAt(index))),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
          ),
        ),
      ),
    );
  }

  Card flatFormat2Card() {
    return Card(
      elevation: defaultPadding / 4,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedFormat == 3 ? primaryColor : Colors.transparent,
          ),
        ),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: flatFormat2.length,
          itemBuilder: (context, index) =>
              Center(child: Text(flatFormat2.elementAt(index))),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
          ),
        ),
      ),
    );
  }
}
