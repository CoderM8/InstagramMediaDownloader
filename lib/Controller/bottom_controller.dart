import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instavideo_downloader/UI/download_screen.dart';
import 'package:instavideo_downloader/UI/hashtagscreen.dart';
import 'package:instavideo_downloader/UI/home_screen.dart';
import 'package:instavideo_downloader/UI/more_screen.dart';

class BottomController extends GetxController {
  RxInt selectedIndex = 0.obs;

  RxList<Widget> bottomPages = <Widget>[
    HomeScreen(),
    HashGenerator(),
    DownloadScreen(),
    const MoreScreen(),
  ].obs;
}
