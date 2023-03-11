import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({super.key});

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      semanticChildCount: 10,
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: const [
          QuiltedGridTile(2, 2),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 2),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        (context, index) => Image.asset(
          'assets/banner/login_banner.jpeg',
          fit: BoxFit.cover,
        ),
        childCount: 20,
      ),
    );
  }
}
