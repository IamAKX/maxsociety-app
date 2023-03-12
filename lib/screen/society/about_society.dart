import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maxsociety/model/society_model.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';

class AboutSocietyScreen extends StatefulWidget {
  const AboutSocietyScreen({super.key});
  static const String routePath = '/aboutSocietyScreen';

  @override
  State<AboutSocietyScreen> createState() => _AboutSocietyScreenState();
}

class _AboutSocietyScreenState extends State<AboutSocietyScreen> {
  late ApiProvider _api;
  SocietyModel? societyModel;
  String address = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadSocietData(),
    );
  }

  loadSocietData() async {
    societyModel = await _api.getSociety();
    address =
        '${societyModel?.societyDetails?.societyName},\n${societyModel?.address?.addressLine1},\n${societyModel?.address?.addressLine2},\n${societyModel?.address?.city},${societyModel?.address?.state} - ${societyModel?.address?.zipCode}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'About Society'),
      ),
      body: getBody(context),
      backgroundColor: backgroundDark,
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              color: dividerColor,
            ),
            borderRadius: BorderRadius.circular(defaultPadding / 4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ADDRESS',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  InkWell(
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: address))
                          .then((value) => SnackBarService.instance
                              .showSnackBarSuccess('Address copied'));
                    },
                    child: const Icon(
                      Icons.copy,
                      size: 20,
                      color: primaryColor,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              Text(
                address,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: defaultPadding * 1.5,
        ),
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              color: dividerColor,
            ),
            borderRadius: BorderRadius.circular(defaultPadding / 4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'OTHER DETAILS',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  InkWell(
                    onTap: () {
                      launchUrl(
                          Uri.parse('tel:${societyModel?.phoneNo ?? ''}'));
                    },
                    child: const Icon(
                      Icons.call_outlined,
                      size: 20,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              detailRow(context, 'Rera Reg. No.',
                  '${societyModel?.societyDetails?.reraRegNo}'),
              detailRow(context, 'Soceity Registration Number',
                  '${societyModel?.societyDetails?.societyRegNo}'),
              detailRow(context, 'Ward No.',
                  '${societyModel?.societyDetails?.wardNo}'),
            ],
          ),
        ),
      ],
    );
  }

  Row detailRow(BuildContext context, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}
