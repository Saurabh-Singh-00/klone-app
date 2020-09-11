import 'package:zingo/managers/manager.dart';
import 'package:zingo/services/preferences.dart';

class AppBLoC {
  final Map<Type, Manager> managers;
  Preferences preferences = Preferences();

  AppBLoC({this.managers});

  Manager fetch(Type manager) {
    return managers[manager];
  }
}
