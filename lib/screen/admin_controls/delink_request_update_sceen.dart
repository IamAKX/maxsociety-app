import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/model/delink_model.dart';
import 'package:maxsociety/model/list/delink_list_model.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/enums.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';

import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/theme.dart';
import 'create_flat.dart';

class DelinkRequestUpdateScreen extends StatefulWidget {
  const DelinkRequestUpdateScreen({super.key});
  static const String routePath = '/adminControls/delinkReqUpdate';

  @override
  State<DelinkRequestUpdateScreen> createState() =>
      _DelinkRequestUpdateScreenState();
}

class _DelinkRequestUpdateScreenState extends State<DelinkRequestUpdateScreen> {
  late ApiProvider _api;
  DelinkListModel? delinkList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadScreen(),
    );
  }

  loadScreen() async {
    _api.getAllPendingDelinkRequest().then((value) {
      setState(() {
        delinkList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Delink Request'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    if (_api.status == ApiStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_api.status == ApiStatus.failed) {
      return Center(
        child: Text(
          'No Request found',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }
    if (delinkList?.data?.isEmpty ?? true) {
      return Center(
        child: Text(
          'No Request found',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }
    return ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            elevation: defaultPadding / 2,
            margin: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CachedNetworkImage(
                    imageUrl:
                        delinkList?.data?.elementAt(index).user?.imagePath ??
                            '',
                    width: homePageUserIconSize,
                    height: homePageUserIconSize,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/image/user.png',
                      width: homePageUserIconSize,
                      height: homePageUserIconSize,
                    ),
                  ),
                  title: Text(
                    delinkList?.data?.elementAt(index).user?.userName ?? '',
                  ),
                  subtitle: Text(
                    delinkList?.data?.elementAt(index).user?.flats?.flatNo ??
                        '',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          DelinkModel? d = delinkList?.data?.elementAt(index);
                          await _api
                              .updateDeRegistrationRequest(
                                  d?.user?.userId ?? '',
                                  d?.user?.userName ?? '',
                                  d?.id ?? 0,
                                  DelinkStatus.REJECT.name)
                              .then((value) {
                            loadScreen();
                          });
                        },
                        icon: Icon(
                          Icons.cancel_rounded,
                          color: Colors.red.withOpacity(0.8),
                          size: 40,
                        ),
                      ),
                      const SizedBox(
                        width: defaultPadding / 4,
                      ),
                      IconButton(
                        onPressed: () async {
                          DelinkModel? d = delinkList?.data?.elementAt(index);
                          await _api
                              .updateDeRegistrationRequest(
                                  d?.user?.userId ?? '',
                                  d?.user?.userName ?? '',
                                  d?.id ?? 0,
                                  DelinkStatus.ACCEPT.name)
                              .then((value) {
                            loadScreen();
                          });
                        },
                        icon: Icon(
                          Icons.check_circle,
                          color: Colors.green.withOpacity(0.8),
                          size: 40,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: delinkList?.data?.length ?? 0);
  }
}
