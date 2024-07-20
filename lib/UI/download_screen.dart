import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instavideo_downloader/Constant/constant.dart';
import 'package:instavideo_downloader/Controller/download_controller.dart';
import 'package:instavideo_downloader/Controller/refresh_controller.dart';
import 'package:instavideo_downloader/UI/post_screen.dart';
import 'package:instavideo_downloader/UI/video_screen.dart';
import '../Database/database.dart';
import '../Database/download_model.dart';

class DownloadScreen extends StatelessWidget {
  DownloadScreen({super.key});

  final RefreshController refreshController = Get.put(RefreshController());
  final DownloadController downloadController = Get.put(DownloadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: TextModel(text: 'Collection', fontFamily: 'B', fontSize: 16.sp),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: <Color>[
            Color(0xfff9ce34),
            Color(0xffee2a7b),
            Color(0xff6228d7),
          ])),
        ),
        bottom: TabBar(
          indicatorColor: Colors.white,
          labelStyle: TextStyle(fontFamily: 'SM', fontSize: 16.sp),
          controller: downloadController.tabController,
          tabs: const [Tab(text: "Video"), Tab(text: "Image")],
        ),
      ),
      body: TabBarView(
        controller: downloadController.tabController,
        children: [reelDownloadPage(), postDownloadPage()],
      ),
    );
  }

  Widget reelDownloadPage() {
    return Obx(() {
      refreshController.isRefresh.value;
      downloadController.isdelete.value;
      return FutureBuilder<List<Download>>(
          future: DatabaseHelper().getDownload('Video'),
          builder: (context, snap) {
            if (snap.hasData) {
              if (snap.data!.isNotEmpty) {
                return GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  itemCount: snap.data!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisSpacing: 5.0.r, mainAxisSpacing: 5.0.r, childAspectRatio: 0.8, crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black, borderRadius: BorderRadius.circular(10.r), image: DecorationImage(image: FileImage(File(snap.data![index].imagepath!)), fit: BoxFit.cover)),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                Get.to(() => VideoScreen(index: index, video: snap.data!));
                              },
                              child: Container(
                                  height: 50.w,
                                  width: 50.w,
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                                  child: SvgPicture.asset('assets/icons/play.svg', color: Colors.white)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.h, right: 10.w),
                          child: InkWell(
                              onTap: () async {
                                downloadController.isdelete.value = true;
                                downloadController.isdelete.value = false;
                                await DatabaseHelper().deleteDownload(snap.data![index].id!);
                              },
                              child: Container(
                                  height: 40.w,
                                  width: 40.w,
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                                  child: SvgPicture.asset('assets/icons/delete.svg', color: Colors.white))),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/collection.svg', height: 100.w, width: 100.w),
                    SizedBox(height: 10.h),
                    TextModel(text: 'No Videos Found!', fontFamily: 'M', color: Colors.black, fontSize: 16.sp),
                  ],
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    });
  }

  Widget postDownloadPage() {
    return Obx(() {
      refreshController.isRefresh.value;
      downloadController.isdelete.value;
      return FutureBuilder<List<Download>>(
          future: DatabaseHelper().getDownload('Image'),
          builder: (context, snap) {
            if (snap.hasData) {
              if (snap.data!.isNotEmpty) {
                return GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  itemCount: snap.data!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisSpacing: 5.0.w, mainAxisSpacing: 5.0.h, childAspectRatio: 0.8, crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(() => PostScreen(index: index, post: snap.data!));
                      },
                      child: Container(
                        height: MediaQuery.sizeOf(context).height,
                        width: MediaQuery.sizeOf(context).width,
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                            color: Colors.black, borderRadius: BorderRadius.circular(10.r), image: DecorationImage(image: FileImage(File(snap.data![index].imagepath!)), fit: BoxFit.cover)),
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.h, right: 10.w),
                          child: InkWell(
                              onTap: () async {
                                downloadController.isdelete.value = true;
                                downloadController.isdelete.value = false;
                                await DatabaseHelper().deleteDownload(snap.data![index].id!);
                              },
                              child: Container(
                                  height: 35.w,
                                  width: 35.w,
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                                  child: SvgPicture.asset('assets/icons/delete.svg', color: Colors.white))),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/collection.svg', height: 100.w, width: 100.w),
                    SizedBox(height: 10.h),
                    TextModel(text: 'No Images Found!', fontFamily: 'M', color: Colors.black, fontSize: 16.sp),
                  ],
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    });
  }
}
