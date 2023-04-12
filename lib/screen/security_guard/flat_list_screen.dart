import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/flat_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/theme.dart';
import '../../widget/heading.dart';

class FlatListScreen extends StatefulWidget {
  const FlatListScreen({super.key});
  static const String routePath = '/securityGuard/flat';
  @override
  State<FlatListScreen> createState() => _FlatListScreenState();
}

class _FlatListScreenState extends State<FlatListScreen> {
  late ApiProvider _api;
  List<FlatModel> flatList = [];
  List<FlatModel> originalFlatList = [];
  FlatModel? selectedFlat;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        loadFlats();
      },
    );
  }

  loadFlats() async {
    _api.getFlatList().then((value) {
      originalFlatList.clear();
      flatList.clear();

      originalFlatList = value.data ?? [];
      flatList.addAll(originalFlatList);
    });
    _searchCtrl.addListener(() {
      setState(() {
        if (_searchCtrl.text.isEmpty) {
          flatList.clear();
          flatList.addAll(originalFlatList);
        } else {
          flatList.clear();
          flatList = originalFlatList
              .where((element) =>
                  element.flatNo
                      ?.toLowerCase()
                      .contains(_searchCtrl.text.toLowerCase()) ??
                  false)
              .toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Select Flat'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(selectedFlat?.flatNo ?? '');
              log('sending : ${selectedFlat?.flatNo ?? ''}');
            },
            child: const Text('Choose'),
          ),
        ],
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    if (_api.status == ApiStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    // if (flatList.isEmpty) {
    //   return Center(
    //     child: Text(
    //       'No flat found',
    //       style: Theme.of(context).textTheme.titleLarge,
    //     ),
    //   );
    // }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding / 2,
            vertical: defaultPadding / 2,
          ),
          child: TextField(
            controller: _searchCtrl,
            maxLines: 1,
            decoration: secondaryTextFieldDecoration('Search Flat'),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  setState(() {
                    selectedFlat = flatList.elementAt(index);
                  });
                },
                tileColor:
                    selectedFlat?.flatNo == (flatList.elementAt(index).flatNo)
                        ? primaryColor.withOpacity(0.1)
                        : Colors.white,
                title: Text(flatList.elementAt(index).flatNo ?? ''),
                subtitle: Text(
                    '${flatList.elementAt(index).tower}  |  ${flatList.elementAt(index).type}'),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              color: dividerColor,
            ),
            itemCount: flatList.length,
          ),
        ),
      ],
    );
  }
}
