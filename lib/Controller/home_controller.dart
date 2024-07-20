import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:instavideo_downloader/Constant/constant.dart';
import 'package:instavideo_downloader/Database/database.dart';
import 'package:instavideo_downloader/Database/download_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart' as wb;

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  RxInt tabIndex = 0.obs;
  RxBool isloadReel = false.obs;
  RxBool isloadPost = false.obs;
  RxBool isLogin = false.obs;
  List<String> urlList = [];
  String postSingleUrl = '';
  String postSingleUrlId = '';
  String postMultipleUrlId = '';
  String reelUrl = '';
  String reelUrlId = '';
  String reelUrlImage = '';
  Dio dio = Dio();

  final CookieManager cookie = CookieManager.instance();

  TextEditingController testController = TextEditingController();
  TextEditingController reelController = TextEditingController();
  TextEditingController storyController = TextEditingController();
  TextEditingController postController = TextEditingController();

  @override
  Future<void> onInit() async {
    isLogin.value = box.read('isLogin') ?? false;
    tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    tabController!.index = 0;
    tabController!.addListener(scroll);
    super.onInit();
  }

  scroll() {
    tabIndex.value = tabController!.index;
  }

  /// Instagram Reel Download (Public & Private)

  Future<void> fetchReelData(String link) async {
    reelUrl = '';
    reelUrlImage = '';
    reelUrlId = '';
    FocusManager.instance.primaryFocus!.unfocus();
    final cookieManager = wb.WebviewCookieManager();
    final gotCookies = await cookieManager.getCookies('https://www.instagram.com/accounts/onetap/?next=%2F');

    if (isLogin.value == true) {
      isloadReel.value = true;
      final linkParts = link.replaceAll(" ", "").split("/");
      final url = '${linkParts[0]}//${linkParts[2]}/${linkParts[3]}/${linkParts[4]}?__a=1&__d=dis';
      final httpClient = HttpClient();

      try {
        final HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
        for (final element in gotCookies) {
          request.cookies.add(element);
        }
        final HttpClientResponse response = await request.close();
        if (response.statusCode == 200) {
          final String json = await response.transform(utf8.decoder).join();
          final data = jsonDecode(json);
          reelUrl = data['items'][0]['video_versions'][0]['url'];
          reelUrlImage = data['items'][0]['image_versions2']['candidates'][0]['url'];
          reelUrlId = data['items'][0]['id'];
        }
      } catch (e) {
        debugPrint('fetchReelData ERROR $e');
        reelUrl = '';
        reelUrlImage = '';
        showToast(message: 'Invalid status-code!');
        isloadReel.value = false;
      }

      // Download video & save
      if (reelUrl.isNotEmpty) {
        try {
          Directory? appDocDir = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
          String savePath = "${appDocDir!.path}/$reelUrlId.mp4";
          String savePathImage = "${appDocDir.path}/$reelUrlId.jpg";

          if (isAndroidVersionUp13) {
            await dio.download(reelUrl, savePath);
            await dio.download(reelUrlImage, savePathImage);
            await DatabaseHelper().addDownload(Download(videopath: savePath, type: 'Video', imagepath: savePathImage));
            isloadReel.value = false;
            reelController.clear();
            showToast(message: 'Video preview show in Collection');
          } else {
            if (await Permission.storage.request().isGranted) {
              await dio.download(reelUrl, savePath);
              await dio.download(reelUrlImage, savePathImage);
              await DatabaseHelper().addDownload(Download(videopath: savePath, type: 'Video', imagepath: savePathImage));
              isloadReel.value = false;
              reelController.clear();
              showToast(message: 'Video preview show in Collection');
            }
          }
        } catch (e, t) {
          if (kDebugMode) {
            print('fetchReelData ERROR $e');
            print('fetchReelData $t');
          }
          showToast(message: 'Something went wrong in finding!');
          isloadReel.value = false;
        }
      } else {
        isloadReel.value = false;
      }
    } else {
      isloadReel.value = false;
      await loginInstaDialog();
    }
  }

  /// Instagram Posts Download (Public & Private) (Single & Multiple Post)

  Future<void> fetchPostData(String link) async {
    urlList.clear();
    postSingleUrl = '';
    FocusManager.instance.primaryFocus!.unfocus();

    final cookieManager = wb.WebviewCookieManager();
    final gotCookies = await cookieManager.getCookies('https://www.instagram.com/accounts/onetap/?next=%2F');

    if (isLogin.value == true) {
      isloadPost.value = true;
      final linkParts = link.replaceAll(" ", "").split("/");
      final url = '${linkParts[0]}//${linkParts[2]}/${linkParts[3]}/${linkParts[4]}?__a=1&__d=dis';
      final httpClient = HttpClient();
      try {
        final HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
        for (final element in gotCookies) {
          request.cookies.add(element);
        }
        final HttpClientResponse response = await request.close();
        if (response.statusCode == 200) {
          final String json = await response.transform(utf8.decoder).join();
          final data = jsonDecode(json);

          /// Multiple Post
          if (data['items'][0]['product_type'] == 'carousel_container') {
            List<dynamic> carouselMedia = data['items'][0]['carousel_media'];
            postMultipleUrlId = data['items'][0]['id'];
            for (final item in carouselMedia) {
              String imageUrl = item['image_versions2']['candidates'][0]['url'];
              urlList.add(imageUrl);
            }
            for (int i = 0; i < urlList.length; i++) {
              final postUrl = urlList[i];
              try {
                Directory? appDocDir = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
                String savePath = "${appDocDir!.path}/$postMultipleUrlId/post$i.jpg";
                if (isAndroidVersionUp13) {
                  await dio.download(postUrl, savePath);
                  await DatabaseHelper().addDownload(Download(imagepath: savePath, type: 'Image'));
                  isloadPost.value = false;
                  showToast(message: 'Image preview show in Collection');
                  postController.clear();
                } else {
                  if (await Permission.storage.request().isGranted) {
                    await dio.download(postUrl, savePath);
                    await DatabaseHelper().addDownload(Download(imagepath: savePath, type: 'Image'));
                    isloadPost.value = false;
                    showToast(message: 'Image preview show in Collection');
                    postController.clear();
                  }
                }
              } catch (e, t) {
                if (kDebugMode) {
                  print('fetchPostData multiple ERROR $e');
                  print('fetchPostData multiple $t');
                }
                showToast(message: 'Something went wrong in Finding!');
                isloadPost.value = false;
                postSingleUrl = '';
                urlList.clear();
              }
            }
          }

          /// Single Post
          else {
            postSingleUrl = data['items'][0]['image_versions2']['candidates'][0]['url'];
            postSingleUrlId = data['items'][0]['id'];
            if (postSingleUrl.isNotEmpty) {
              try {
                Directory? appDocDir = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
                String savePath = "${appDocDir!.path}/$postSingleUrlId.jpg";
                if (isAndroidVersionUp13) {
                  await dio.download(postSingleUrl, savePath);
                  await DatabaseHelper().addDownload(Download(imagepath: savePath, type: 'Image'));
                  isloadPost.value = false;
                  postController.clear();
                  showToast(message: 'Image preview show in Collection');
                } else {
                  if (await Permission.storage.request().isGranted) {
                    await dio.download(postSingleUrl, savePath);
                    await DatabaseHelper().addDownload(Download(imagepath: savePath, type: 'Image'));
                    isloadPost.value = false;
                    postController.clear();
                    showToast(message: 'Image preview show in Collection');
                  }
                }
              } catch (e) {
                showToast(message: 'Something went wrong in Finding!');
                isloadPost.value = false;
              }
            } else {
              isloadPost.value = false;
            }
          }
        }
      } catch (e, t) {
        if (kDebugMode) {
          print('fetchPostData Single ERROR $e');
          print('fetchPostData Single $t');
        }
        showToast(message: 'Invalid status-code!');
        isloadPost.value = false;
      }
    } else {
      isloadPost.value = false;
      await loginInstaDialog();
    }
  }
}
