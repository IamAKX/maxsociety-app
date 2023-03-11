import 'package:flutter/material.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/theme.dart';

class VideoGallery extends StatefulWidget {
  const VideoGallery({super.key});

  @override
  State<VideoGallery> createState() => _VideoGalleryState();
}

class _VideoGalleryState extends State<VideoGallery> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return Card(
          elevation: defaultPadding / 2,
          margin: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/banner/login_banner.jpeg',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 50,
                    left: (MediaQuery.of(context).size.width - 100) / 2,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.play_circle_outline,
                        color: Colors.black.withOpacity(0.6),
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: defaultPadding / 2,
                  right: defaultPadding / 2,
                  top: defaultPadding / 2,
                ),
                child: Text(
                  'Video Title $index',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: defaultPadding / 2,
                  right: defaultPadding / 2,
                  bottom: defaultPadding / 2,
                ),
                child: Text(
                  '${21 - index} days ago',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
