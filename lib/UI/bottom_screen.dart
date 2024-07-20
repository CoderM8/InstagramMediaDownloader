import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instavideo_downloader/Constant/constant.dart';
import 'package:instavideo_downloader/Controller/bottom_controller.dart';
import 'package:instavideo_downloader/Controller/refresh_controller.dart';

class BottomScreen extends StatelessWidget {
  BottomScreen({super.key});

  final BottomController bottomController = Get.put(BottomController());
  final RefreshController refreshController = Get.put(RefreshController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        bottomController.selectedIndex.value;
        return IndexedStack(index: bottomController.selectedIndex.value, children: bottomController.bottomPages);
      }),
      bottomNavigationBar: Obx(() {
        bottomController.selectedIndex.value;
        return BottomNavigationBar(
          onTap: (int index) {
            bottomController.selectedIndex.value = index;
            refreshController.isRefresh.value = !refreshController.isRefresh.value;
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0.0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/home.svg', height: 25.w, width: 25.w),
                label: "Home",
                activeIcon: SvgPicture.asset('assets/icons/home.svg', color: purpleColor, height: 25.w, width: 25.w)),
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/hashtag.svg', height: 25.w, width: 25.w),
                label: "HashTag",
                activeIcon: SvgPicture.asset('assets/icons/hashtag.svg', color: purpleColor, height: 25.w, width: 25.w)),
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/collection.svg', height: 25.w, width: 25.w),
                activeIcon: SvgPicture.asset('assets/icons/collection.svg', color: purpleColor, height: 25.w, width: 25.w),
                label: 'Collection'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/more.svg', height: 25.w, width: 25.w),
                activeIcon: SvgPicture.asset('assets/icons/more.svg', color: purpleColor, height: 25.w, width: 25.w),
                label: 'More'),
          ],
          selectedItemColor: purpleColor,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(fontSize: 12.sp, fontFamily: 'M'),
          showUnselectedLabels: true,
          unselectedLabelStyle: TextStyle(fontSize: 12.sp, fontFamily: 'M'),
          currentIndex: bottomController.selectedIndex.value,
        );
      }),
    );
  }
}
