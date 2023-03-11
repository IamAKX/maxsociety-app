import 'package:flutter/material.dart';
import 'package:maxsociety/screen/profile/add_vehicle_screen.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/heading.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});
  static const String routePath = '/vehicleScreen';

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Vehicle'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddVehicleScreen.routePath);
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
    return ListView.builder(
      padding: const EdgeInsets.all(defaultPadding),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Card(
          elevation: defaultPadding / 2,
          margin: const EdgeInsets.symmetric(
            vertical: defaultPadding / 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/image/democar.jpeg',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Row(
                  children: [
                    Text(
                      'Hyundai i20',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: textColorDark,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      '4-Wheeler',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: textColorDark,
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Row(
                  children: [
                    Text(
                      'PY 05 J 859$index',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: textColorDark,
                          ),
                    ),
                    const Spacer(),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
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
