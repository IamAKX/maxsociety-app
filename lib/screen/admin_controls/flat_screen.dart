import 'package:flutter/material.dart';
import 'package:maxsociety/screen/admin_controls/create_flat.dart';
import 'package:maxsociety/util/constants.dart';

import '../../util/colors.dart';
import '../../widget/heading.dart';

class FlatScreen extends StatefulWidget {
  const FlatScreen({super.key});
  static const String routePath = '/adminControls/flat';
  @override
  State<FlatScreen> createState() => _FlatScreenState();
}

class _FlatScreenState extends State<FlatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'All Flat'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(CreateFlat.routePath)
                  .then((value) {
                setState(() {});
              });
            },
            child: const Text('Create'),
          ),
        ],
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: flatFormat1.length,
      itemBuilder: (context, index) => Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: dividerColor),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(flatFormat1.elementAt(index)),
        ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
      ),
    );
  }
}
