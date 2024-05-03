import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nylo/components/buttons/rounded_button_with_progress.dart';
import 'package:nylo/components/information_snackbar.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: SvgPicture.asset(
                      "assets/icons/clarity_no-wifi-solid.svg"),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "No Connection",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Please check your internet connection, you are in offline now.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                RoundedButtonWithProgress(
                  text: "Connect",
                  onTap: () async {
                    bool result =
                        await InternetConnectionChecker().hasConnection;
                    if (result) {
                      Navigator.of(context).pop();
                    } else {
                      final ScaffoldMessengerState messenger =
                          ScaffoldMessenger.of(context);
                      informationSnackBar(
                          context,
                          messenger,
                          Icons.signal_wifi_connected_no_internet_4_outlined,
                          "No internet connection found");
                    }
                  },
                  margin: const EdgeInsets.all(0),
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  textcolor: Theme.of(context).colorScheme.background,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
