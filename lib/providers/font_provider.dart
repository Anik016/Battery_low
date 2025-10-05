import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Font size provider
final fontProvider = NotifierProvider<FontNotifier, double>(FontNotifier.new);

class FontNotifier extends Notifier<double> {
  @override
  double build() {
    // default font size
    return 16.0;
  }

  void increase() {
    state = state + 2;
  }

  void decrease() {
    state = (state - 2).clamp(10.0, 100.0);
  }

  void setSize(double size) {
    state = size.clamp(10.0, 100.0);
  }
}
