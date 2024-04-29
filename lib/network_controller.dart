import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:nylo/pages/home/no_internet.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    final hasConnection = connectivityResults.contains(ConnectivityResult.none);
    if (hasConnection) {
      print("DISCONNECTED");

      Get.to(const NoInternet());
    } else {
      print("CONNECTED");
    }
  }
}
