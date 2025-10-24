// --- في ملف: lib/core/viewmodel/banner_controller.dart ---

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  // 1. المتغيرات التي يديرها الكنترولر
  late final PageController pageController;
  Timer? _timer;
  final RxInt currentPage = 0.obs;

  final List<String> banners = [
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&q=60',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&q=60',
    'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&q=60',
  ];

  // 2. يتم استدعاؤها عند بدء تشغيل الكنترولر
  @override
  void onInit( ) {
    super.onInit();
    pageController = PageController();
    _startTimer();
  }

  // 3. يتم استدعاؤها عند إغلاق الكنترولر
  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  // 4. دالة بدء المؤقت
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      int nextPage;
      if (currentPage.value < banners.length - 1) {
        nextPage = currentPage.value + 1;
      } else {
        nextPage = 0;
      }

      if (pageController.hasClients) {
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }

  // 5. دالة تحديث الصفحة الحالية عند التمرير اليدوي
  void onPageChanged(int index) {
    currentPage.value = index;
  }
}
