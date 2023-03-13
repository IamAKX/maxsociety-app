import 'package:flutter/material.dart';
import 'package:maxsociety/model/flat_model.dart';
import 'package:maxsociety/screen/admin_controls/create_flat.dart';
import 'package:maxsociety/screen/admin_controls/update_flat.dart';
import 'package:maxsociety/util/constants.dart';
import 'package:provider/provider.dart';

import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../widget/heading.dart';

class FlatScreen extends StatefulWidget {
  const FlatScreen({super.key});
  static const String routePath = '/adminControls/flat';
  @override
  State<FlatScreen> createState() => _FlatScreenState();
}

class _FlatScreenState extends State<FlatScreen> {
  late ApiProvider _api;
  List<FlatModel> flatList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadFlats(),
    );
  }

  loadFlats() async {
    _api.getFlatList().then((value) {
      setState(() {
        flatList = value.data ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'All Flat'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(CreateFlat.routePath)
                  .then((value) {
                loadFlats();
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
      itemCount: flatList.length,
      itemBuilder: (context, index) => Center(
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(UpdateFlat.routePath,
                    arguments: flatList.elementAt(index))
                .then((value) => loadFlats());
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: dividerColor),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text('${flatList.elementAt(index).flatNo}'),
          ),
        ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
      ),
    );
  }
}
