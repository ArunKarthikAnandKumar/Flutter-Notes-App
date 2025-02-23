import 'package:flutter/material.dart' show BuildContext, ModalRoute;

extension GetArguements on BuildContext {
  T? getArguement<T>() {
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}
