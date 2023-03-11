import 'package:flutter/material.dart';
import 'package:maxsociety/screen/gallery/photo_gallery.dart';
import 'package:maxsociety/screen/gallery/video_gallery.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: dividerColor.withOpacity(0.4),
        appBar: AppBar(
          title: Heading(title: 'Gallery'),
          bottom: TabBar(
            tabs: const [
              Tab(
                text: 'Photos',
              ),
              Tab(
                text: 'Videos',
              ),
            ],
            labelColor: textColorDark,
            unselectedLabelColor: hintColor,
            indicatorColor: primaryColor,
            indicator: MaterialIndicator(
              height: 5,
              topLeftRadius: 8,
              topRightRadius: 8,
              horizontalPadding: 50,
              tabPosition: TabPosition.bottom,
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            PhotoGallery(),
            VideoGallery(),
          ],
        ),
      ),
    );
  }
}
