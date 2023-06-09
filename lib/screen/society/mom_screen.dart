import 'package:flutter/material.dart';
import 'package:maxsociety/screen/admin_controls/create_mom_screen.dart';
import 'package:maxsociety/screen/society/mom_details.dart';
import 'package:maxsociety/util/helper_methods.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';

import '../../model/circular_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/datetime_formatter.dart';
import '../../util/enums.dart';
import '../../util/messages.dart';

class MomScreen extends StatefulWidget {
  const MomScreen({super.key});
  static const String routePath = '/momScreen';

  @override
  State<MomScreen> createState() => _MomScreenState();
}

class _MomScreenState extends State<MomScreen> {
  late ApiProvider _api;
  List<CircularModel> circularList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadCirculars(),
    );
  }

  loadCirculars() async {
    _api.getCircularsByCircularType(CircularType.MOM.name).then((value) {
      setState(() {
        circularList = value.data ?? [];
        circularList.sort(((a, b) => int.parse(a.circularNo ?? '0')
            .compareTo(int.parse(b.circularNo ?? '0'))));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(
          title: 'Minute Of Meeting',
          overrideFontSize: 28,
        ),
        actions: [
          if (isAdminUser())
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(CreateMomScreen.routePath)
                    .then((value) {
                  loadCirculars();
                });
              },
              child: const Text('Create'),
            )
        ],
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    if (_api.status == ApiStatus.failed) {
      return Center(
        child: Text(
          'No MOM found',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: primaryColor.withOpacity(0.1),
              child: Text('${circularList.elementAt(index).circularNo}'),
            ),
            title: Text(
              circularList.elementAt(index).subject ?? '',
              maxLines: 2,
            ),
            subtitle: Text(
              'Held on ${eventDateToDate(circularList.elementAt(index).eventDate ?? '')}',
              maxLines: 2,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(MomDetailScreen.routePath,
                      arguments: circularList.elementAt(index).circularId)
                  .then((value) => loadCirculars());
            },
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: dividerColor,
          );
        },
        itemCount: circularList.length);
  }
}
