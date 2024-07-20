import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TagController extends GetxController {
  final RxList hashtags = [].obs;
  RxList searchTags = [].obs;
  final TextEditingController controller = TextEditingController();

  @override
  Future<void> onInit() async {
    final String response = await rootBundle.loadString('assets/hashtag.json');
    final data = await json.decode(response);
    hashtags.addAll(data['Hashtag']);
    hashtags.sort((a, b) => a['_title'].toString().compareTo(b['_title']));
    searchTags.addAll(hashtags);
    super.onInit();
  }
}
