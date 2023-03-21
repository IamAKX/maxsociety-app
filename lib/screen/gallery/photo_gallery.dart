import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maxsociety/model/gallery_model.dart';
import 'package:maxsociety/util/datetime_formatter.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:provider/provider.dart';

import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../service/storage_service.dart';
import '../../util/enums.dart';
import '../../util/helper_methods.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/image_viewer.dart';

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({super.key});

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  late ApiProvider _api;
  List<GalleryModel> list = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadGallery(),
    );
  }

  loadGallery() async {
    await _api.getGalleryItems().then((value) {
      list = value.data ?? [];
      list.removeWhere(
          (element) => element.galleryItemType == GalleryItemType.VIDEO.name);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      floatingActionButton: isAdminUser()
          ? FloatingActionButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['png', 'jpg', 'jpeg'],
                );

                if (result != null) {
                  File file = File(result.files.single.path!);
                  showFileUploadPopup(file, context);
                }
              },
              elevation: defaultPadding,
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/logo/image_upload.png',
                width: 35,
              ),
            )
          : null,
      body: GridView.custom(
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
          (context, index) => InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(ImageViewer.routePath,
                  arguments: list.elementAt(index).galleryItemPath ?? '');
            },
            onLongPress: () {
              showDeletePopup(context, list.elementAt(index));
            },
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                CachedNetworkImage(
                  imageUrl: list.elementAt(index).galleryItemPath ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/image/404.jpg',
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 5,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      eventTimesAgoShort(
                        list.elementAt(index).createdOn ?? '',
                      ),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                )
              ],
            ),
          ),
          childCount: list.length,
        ),
      ),
    );
  }

  void showFileUploadPopup(File file, BuildContext context) {
    TextEditingController _nameCtrl = TextEditingController();
    AlertDialog alert = AlertDialog(
      title: const Text("Enter image title"),
      content: CustomTextField(
          hint: 'Title',
          controller: _nameCtrl,
          keyboardType: TextInputType.name,
          obscure: false,
          icon: Icons.image),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_nameCtrl.text.isEmpty) {
              SnackBarService.instance.showSnackBarInfo('Enter image title');
              return;
            }
            Navigator.of(context).pop();
            String imageUrl = '';

            SnackBarService.instance
                .showSnackBarInfo('Uploading file, please wait');
            imageUrl = await StorageService.uploadEventImage(
              file,
              getFileName(file),
              StorageFolders.galleryImage.name,
            );
            var reqBody = {
              'galleryItemName': _nameCtrl.text,
              'galleryItemType': GalleryItemType.IMAGE.name,
              'galleryItemPath': imageUrl.trim(),
              "society": {'societyCode': 1}
            };
            _api.createGalleryItem(reqBody).then((value) {
              if (value) {
                loadGallery();
              }
            });
          },
          child: const Text('Upload'),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showDeletePopup(BuildContext context, GalleryModel item) {
    AlertDialog alert = AlertDialog(
      title: const Text("Delete photo"),
      content: const Text('Are you sure you want to delete this photo?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();

            _api.deleteGalleryItem(item.galleryItemId ?? 0).then((value) {
              if (value) {
                loadGallery();
              }
            });
          },
          child: Text(
            'Delete',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Colors.red),
          ),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
