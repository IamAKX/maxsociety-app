import 'package:flutter/material.dart';
import 'package:maxsociety/model/flat_model.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/button_active.dart';

import '../../widget/heading.dart';

class FlatSummary extends StatefulWidget {
  const FlatSummary({super.key, required this.flatList});
  static const String routePath = '/adminControls/flat/summary';
  final List<FlatModel> flatList;

  @override
  State<FlatSummary> createState() => _FlatSummaryState();
}

class _FlatSummaryState extends State<FlatSummary> {
  @override
  Widget build(BuildContext context) {
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
                child: Text(
                    '${widget.flatList.elementAt(index).tower}-${widget.flatList.elementAt(index).flatNo}'),
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
            onPressed: () {},
            label: 'Create',
          ),
        )
      ],
    );
  }
}
