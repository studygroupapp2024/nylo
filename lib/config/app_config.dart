import 'package:nylo/config/app_environments.dart';

class AppConfig {
  static Flavors flavors = Flavors.production;
  static Flavors get environment => flavors;

  static setEnvironment(Flavors environment) {
    switch (environment) {
      case Flavors.development:
        flavors = Flavors.development;
        break;
      case Flavors.staging:
        flavors = Flavors.staging;
        break;
      case Flavors.production:
        flavors = Flavors.production;
        break;
    }
  }
}
