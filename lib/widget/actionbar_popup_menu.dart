import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:maxsociety/model/app_metadata_model.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../service/db_service.dart';
import '../util/preference_key.dart';

class ActionbarPopupMenu extends StatefulWidget {
  const ActionbarPopupMenu({super.key});

  @override
  State<ActionbarPopupMenu> createState() => _ActionbarPopupMenuState();
}

class _ActionbarPopupMenuState extends State<ActionbarPopupMenu> {
  AppMetadataModel? appMetadataModel;
  @override
  Widget build(BuildContext context) {
    if (prefs.containsKey(PreferenceKey.metadata)) {
      appMetadataModel =
          AppMetadataModel.fromJson(prefs.getString(PreferenceKey.metadata)!);
    }
    return SizedBox(
      child: PopupMenuButton(
        position: PopupMenuPosition.under,
        onSelected: (value) {
          _onMenuItemSelected(value as int);
        },
        itemBuilder: (ctx) => [
          _buildPopupMenuItem('Contact Us', Icons.support_agent_outlined, 0),
          _buildPopupMenuItem('Share App', Icons.share_outlined, 1),
          _buildPopupMenuItem('Rate us', Icons.rate_review_outlined, 2),
          _buildPopupMenuItem('Terms', Icons.list_outlined, 3),
          _buildPopupMenuItem('Privacy Policy', Icons.shield_outlined, 4),
        ],
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Icon(
            iconData,
          ),
          const SizedBox(
            width: defaultPadding,
          ),
          Text(title),
        ],
      ),
    );
  }

  _onMenuItemSelected(int value) async {
    if (!prefs.containsKey(PreferenceKey.metadata)) {
      await DBService.instance.getAppMetadata().then((value) {
        setState(() {});
      });
    }
    switch (value) {
      case 0:
        if (appMetadataModel?.contactNo?.isNotEmpty ?? false) {
          launchUrl(Uri.parse('tel:${appMetadataModel?.contactNo}'));
        }
        break;
      case 1:
        if (appMetadataModel?.playStoreLink?.isNotEmpty ?? false) {
          String link = appMetadataModel?.playStoreLink ?? '';
          FlutterShare.share(
            title: 'Install MaxSociety',
            text: 'Install MaxSociety now!',
            linkUrl: link,
            chooserTitle: 'Share MaxSociety App',
          );
        }
        break;
      case 2:
        if (appMetadataModel?.playStoreLink?.isNotEmpty ?? false) {
          String link = appMetadataModel?.playStoreLink ?? '';
          launchUrl(Uri.parse(link));
        }
        break;
      case 3:
        if (appMetadataModel?.termLink?.isNotEmpty ?? false) {
          String link = appMetadataModel?.termLink ?? '';
          launchUrl(Uri.parse(link));
        }
        break;
      case 4:
        if (appMetadataModel?.policyLink?.isNotEmpty ?? false) {
          String link = appMetadataModel?.policyLink ?? '';
          launchUrl(Uri.parse(link));
        }
        break;
    }
  }
}
