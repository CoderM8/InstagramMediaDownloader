import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;
  var controller = PageController();

  List<OnBoarding> onboardinglist = [
    OnBoarding(
        title: "Insta Reel Save",
        imgUrl: "assets/images/onboarding1.jpg",
        description: "Save Instagram Post and reel with this\nInstagram story Saver"),
    OnBoarding(
        title: "Insta Post Save",
        imgUrl: "assets/images/onboarding2.jpg",
        description: "Easy to Save images and reel in the\nmobile gallery"),
    OnBoarding(
        title: "Copy URL of Reel & Post",
        imgUrl: "assets/images/onboarding3.jpg",
        description: "Select any video, picture and post then\ncopy link"),
  ];

  @override
  void onInit() {
    super.onInit();
    controller = PageController(initialPage: 0);
  }
}

class OnBoarding {
  final String title;
  final String imgUrl;
  final String description;

  OnBoarding({required this.title, required this.imgUrl, required this.description});
}
