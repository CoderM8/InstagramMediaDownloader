import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadController extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  RxInt tabIndex = 0.obs;
  RxBool isdelete = false.obs;

  @override
  Future<void> onInit() async {
    tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    tabController!.index = 0;
    tabController!.addListener(scroll);
    super.onInit();
  }

  scroll() {
    tabIndex.value = tabController!.index;
  }
}
