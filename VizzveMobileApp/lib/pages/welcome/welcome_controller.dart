import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  StreamSubscription<ConnectivityResult> ?subscription;
  bool isInternetOn = true;

  @override
  void onInit() {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.wifi:
        case ConnectivityResult.mobile:
          isInternetOn = true;
          update();
          break;
        case ConnectivityResult.none:
          isInternetOn = false;
          update();
          break;
        default:
          isInternetOn = true;
          update();
          break;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    subscription?.cancel();
    super.onClose();
  }
}
