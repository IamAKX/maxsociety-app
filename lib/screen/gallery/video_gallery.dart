import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/datetime_formatter.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/video_viewer.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../model/gallery_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../service/storage_service.dart';
import '../../util/enums.dart';
import '../../util/helper_methods.dart';
import '../../widget/custom_textfield.dart';

class VideoGallery extends StatefulWidget {
  const VideoGallery({super.key});

  @override
  State<VideoGallery> createState() => _VideoGalleryState();
}

class _VideoGalleryState extends State<VideoGallery> {
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
          (element) => element.galleryItemType == GalleryItemType.IMAGE.name);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['mp4'],
          );

          if (result != null) {
            File file = File(result.files.single.path!);
            showFileUploadPopup(file, context);
          }
        },
        elevation: defaultPadding,
        backgroundColor: Colors.white,
        child: Image.asset(
          'assets/logo/video_upload.png',
          width: 35,
        ),
      ),
      body: ListView.builder(
        itemCount: list.length,
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
                    CachedNetworkImage(
                      imageUrl: list.elementAt(index).thumbnail ?? '',
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/image/404.jpg',
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: (MediaQuery.of(context).size.width - 100) / 2,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(VideoViewer.routePath,
                              arguments: list.elementAt(index).galleryItemPath);
                        },
                        icon: Icon(
                          Icons.play_circle_outline,
                          color: Colors.black.withOpacity(0.6),
                          size: 50,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 1,
                      top: 1,
                      child: IconButton(
                        onPressed: () {
                          showDeletePopup(context, list.elementAt(index));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
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
                    list.elementAt(index).galleryItemName ?? '',
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
                    eventTimesAgo(list.elementAt(index).updatedOn ?? ''),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showFileUploadPopup(File file, BuildContext context) {
    TextEditingController _nameCtrl = TextEditingController();
    AlertDialog alert = AlertDialog(
      title: const Text("Enter video title"),
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
              SnackBarService.instance.showSnackBarInfo('Enter video title');
              return;
            }
            Navigator.of(context).pop();
            showLoadingDialogbox(context);
            String imageUrl = '';

            SnackBarService.instance
                .showSnackBarInfo('Uploading file, please wait');
            imageUrl = await StorageService.uploadEventImage(
              file,
              getFileName(file),
              StorageFolders.galleryVideo.name,
            );

            String? thumbnailFile = await VideoThumbnail.thumbnailFile(
              video: imageUrl,

              imageFormat: ImageFormat.JPEG,
              maxHeight:
                  150, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
              quality: 75,
            );

            File tmb = File(thumbnailFile!);
            log('thumbnailFile : $thumbnailFile');
            String tmbUrl = '';
            tmbUrl = await StorageService.uploadEventImage(
              tmb,
              getFileName(file),
              StorageFolders.thumbnail.name,
            );
            log('tmbUrl : $tmbUrl');
            var reqBody = {
              'galleryItemName': _nameCtrl.text,
              'galleryItemType': GalleryItemType.VIDEO.name,
              'galleryItemPath': imageUrl.trim(),
              "society": {'societyCode': 1},
              'thumbnail': tmbUrl
            };
            _api.createGalleryItem(reqBody).then((value) {
              Navigator.of(context).pop();
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

  showLoadingDialogbox(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text("Uploading video"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator(),
          SizedBox(
            height: defaultPadding,
          ),
          Text('Please wait...'),
        ],
      ),
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
      title: const Text("Delete video"),
      content: const Text('Are you sure you want to delete this video?'),
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
