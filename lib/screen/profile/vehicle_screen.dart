import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/model/vehicle_model.dart';
import 'package:maxsociety/screen/profile/add_vehicle_screen.dart';
import 'package:maxsociety/screen/profile/edit_vehicle_screen.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/preference_key.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});
  static const String routePath = '/vehicleScreen';

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  late ApiProvider _api;
  List<VehicleModel> vehicleList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadVehicleData(),
    );
  }

  loadVehicleData() async {
    _api.getVehiclesByFlatNo(userProfile.flats?.flatNo ?? '').then((value) {
      setState(() {
        vehicleList = value.data ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Vehicle'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AddVehicleScreen.routePath)
                  .then((value) => loadVehicleData());
            },
            child: Text(
              'Add Vehicle',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
            ),
          ),
        ],
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    // if (_api.status == ApiStatus.loading) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // } else
    {
      return ListView.builder(
        padding: const EdgeInsets.all(defaultPadding),
        itemCount: vehicleList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: defaultPadding / 2,
            margin: const EdgeInsets.symmetric(
              vertical: defaultPadding / 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: vehicleList.elementAt(index).image ?? '',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/image/car.jpg',
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2),
                  child: Row(
                    children: [
                      Text(
                        '${vehicleList.elementAt(index).brand} ${vehicleList.elementAt(index).model}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: textColorDark,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const Spacer(),
                      Text(
                        '${vehicleList.elementAt(index).vehicleType}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: textColorDark,
                                ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2),
                  child: Row(
                    children: [
                      Text(
                        '${vehicleList.elementAt(index).vehicleNo}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: textColorDark,
                                ),
                      ),
                      const Spacer(),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          _api
                              .deleteVehicle(
                                  vehicleList.elementAt(index).vehicleNo ?? '')
                              .then((value) => loadVehicleData());
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          Navigator.of(context)
                              .pushNamed(EditVehicleScreen.routePath,
                                  arguments:
                                      vehicleList.elementAt(index).vehicleNo ??
                                          '')
                              .then((value) => loadVehicleData());
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
