import 'package:flutter/material.dart';
import 'package:maxsociety/model/flat_model.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/button_active.dart';
import 'package:provider/provider.dart';

import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../widget/heading.dart';

class FlatSummary extends StatefulWidget {
  const FlatSummary({super.key, required this.flatList});
  static const String routePath = '/adminControls/flat/summary';
  final List<FlatModel> flatList;

  @override
  State<FlatSummary> createState() => _FlatSummaryState();
}

class _FlatSummaryState extends State<FlatSummary> {
  late ApiProvider _api;
  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Flat Summary'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: widget.flatList.length,
            itemBuilder: (context, index) => Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: dividerColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text('${widget.flatList.elementAt(index).flatNo}'),
              ),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: ActiveButton(
            onPressed: () async {
              await _api.createFlatInBulk(widget.flatList).then((value) {
                if (true) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              });
            },
            label:
                _api.status == ApiStatus.loading ? 'Please wait...' : 'Create',
            isDisabled: _api.status == ApiStatus.loading,
          ),
        )
      ],
    );
  }
}
