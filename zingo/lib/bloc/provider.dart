import 'package:flutter/widgets.dart';

class Provider<T> extends InheritedWidget {
  final T bloc;
  final Widget child;

  Provider({@required this.bloc, this.child});

  static T of<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider<T>>().bloc;
  }

  @override
  bool updateShouldNotify(Provider<T> oldWidget) {
    return false;
  }
}
