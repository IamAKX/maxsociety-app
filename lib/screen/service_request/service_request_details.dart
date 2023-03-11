import 'package:flutter/material.dart';
import 'package:maxsociety/widget/heading.dart';

import '../../util/colors.dart';
import '../../util/messages.dart';
import '../../util/theme.dart';

class ServiceRequestDetail extends StatefulWidget {
  const ServiceRequestDetail({super.key, required this.reqId});
  final int reqId;
  static const String routePath = '/serviceRequestDetail';

  @override
  State<ServiceRequestDetail> createState() => _ServiceRequestDetailState();
}

class _ServiceRequestDetailState extends State<ServiceRequestDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Request #${widget.reqId}'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          loremIpsumText.substring(0, 100),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Text(
          'Posted from ${widget.reqId} Feb, 2023',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: textColorLight),
        ),
        (widget.reqId - 1 % 2 == 0)
            ? Text(
                'Closed',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
              )
            : Text(
                'Pending',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
              ),
        const SizedBox(height: defaultPadding),
        Text(
          loremIpsumText,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: textColorLight),
        ),
        const SizedBox(height: defaultPadding),
        Text(
          'Images Attached',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: defaultPadding / 2),
        Align(
          alignment: Alignment.centerLeft,
          child: Image.asset(
            'assets/image/demobrokenpipe.jpeg',
            height: 200,
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
        ),
      ],
    );
  }
}
