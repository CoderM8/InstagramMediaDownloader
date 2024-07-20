import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:instavideo_downloader/Constant/chewie_screen.dart';
import 'package:instavideo_downloader/Constant/constant.dart';
import 'package:instavideo_downloader/Database/download_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key, required this.index, required this.video});

  final int index;
  final List<Download> video;

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: index);
    return Scaffold(
      body: PageView.builder(
          controller: pageController,
          scrollDirection: Axis.vertical,
          itemCount: video.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                VideoPlayerScreen(link: video[index].videopath!, img: video[index].imagepath!),
                Positioned(
                  top: 50.h,
                  left: 15.w,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                        height: 40.w,
                        width: 40.w,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(50.r)),
                        child: SvgPicture.asset('assets/icons/left.svg', color: Colors.white)),
                  ),
                ),
                Positioned(
                  bottom: 55.h,
                  right: 10.w,
                  child: Column(
                    children: [
                      RawMaterialButton(
                        padding: EdgeInsets.all(10.r),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        fillColor: Colors.black.withOpacity(0.5),
                        shape: const CircleBorder(),
                        child: SvgPicture.asset(
                          'assets/icons/share.svg',
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Get.dialog(Dialog(
                            insetPadding: EdgeInsets.all(20.w),
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.r),
                                borderSide: BorderSide(color: Colors.transparent)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15.h),
                                TextModel(
                                  text: 'Repost Video',
                                  color: blackColor,
                                  fontSize: 18.sp,
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 15.h),
                                TextModel(
                                  text: 'Can you repost this Video in Instagram?',
                                  color: blackColor,
                                  fontSize: 15.sp,
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 30.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ButtonWidget(
                                        title: 'Cancel',
                                        buttonColor: Colors.grey,
                                        onTap: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: ButtonWidget(
                                        onTap: () {
                                          if (isTab(context)) {
                                            Share.shareXFiles([XFile(video[index].videopath!)],
                                                sharePositionOrigin: Rect.fromLTWH(
                                                    0,
                                                    0,
                                                    MediaQuery.sizeOf(context).width,
                                                    MediaQuery.sizeOf(context).height / 2));
                                            Get.back();
                                          } else {
                                            Share.shareXFiles([XFile(video[index].videopath!)]);
                                            Get.back();
                                          }
                                        },
                                        title: 'Repost',
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ).paddingAll(20.w),
                          ));
                        },
                      ),
                      RawMaterialButton(
                        padding: EdgeInsets.all(10.r),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        fillColor: Colors.black.withOpacity(0.5),
                        shape: const CircleBorder(),
                        child: SvgPicture.asset(
                          'assets/icons/gallery.svg',
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if (Platform.isIOS) {
                            PermissionStatus photos = await Permission.photos.status;
                            if (photos.isDenied) {
                              await Permission.photos.request();
                            } else if (photos.isPermanentlyDenied) {
                              await openAppSettings();
                            }
                            if (photos.isGranted) {
                              await ImageGallerySaver.saveFile(video[index].videopath!, isReturnPathOfIOS: true);
                              showToast(message: 'Reel save in Gallery');
                            }
                          } else {
                            await ImageGallerySaver.saveFile(video[index].videopath!, isReturnPathOfIOS: true);
                            showToast(message: 'Reel save in Gallery');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
