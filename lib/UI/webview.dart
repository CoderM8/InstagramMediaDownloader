import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instavideo_downloader/Constant/constant.dart';
import '../Controller/home_controller.dart';

class WebviewScreen extends StatelessWidget {
  WebviewScreen({super.key});

  final CookieManager cookie = CookieManager.instance();

  InAppWebViewController? webViewController;

  final Completer<InAppWebViewController> controllerCompleter = Completer<InAppWebViewController>();

  HomeController homeController = Get.put(HomeController());
  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: TextModel(text: 'Login Instagram', fontFamily: 'B', fontSize: 18.sp),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.close_rounded, color: Colors.white, size: 30.sp)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: <Color>[
            Color(0xfff9ce34),
            Color(0xffee2a7b),
            Color(0xff6228d7),
          ])),
        ),
      ),
      body: InAppWebView(
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          return NavigationActionPolicy.ALLOW;
        },
        initialSettings: InAppWebViewSettings(javaScriptEnabled: true, supportZoom: false, sharedCookiesEnabled: true, minimumZoomScale: 1.0, maximumZoomScale: 1.0),
        initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse('https://www.instagram.com/accounts/login/'))),
        onWebViewCreated: (InAppWebViewController webViewController) async {
          webViewController = webViewController;
          controllerCompleter.future.then((value) => webViewController = value);
          controllerCompleter.complete(webViewController);
        },
        onLoadStart: (controller, url) async {},
        onLoadStop: (controller, url) async {
          await cookie.setCookie(
            url: WebUri.uri(Uri.parse('https://www.instagram.com/accounts/onetap/?next=%2F')),
            name: 'cookie name',
            value: 'value',
          );
          controller.webStorage.sessionStorage.setItem(key: 'session storage key', value: 'value');
          if (url!.toString().contains('https://www.instagram.com/accounts/onetap/?next=%2F')) {
            showToast(message: 'LogIn Successfully');
            homeController.isLogin.value = true;
            box.write('isLogin', homeController.isLogin.value);
            Get.back();
          }
        },
      ),
    );
  }
}
