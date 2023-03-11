import 'package:flutter/material.dart';
import 'package:maxsociety/util/theme.dart';

class ActionbarPopupMenu extends StatefulWidget {
  const ActionbarPopupMenu({super.key});

  @override
  State<ActionbarPopupMenu> createState() => _ActionbarPopupMenuState();
}

class _ActionbarPopupMenuState extends State<ActionbarPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
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

  _onMenuItemSelected(int value) {}
}
