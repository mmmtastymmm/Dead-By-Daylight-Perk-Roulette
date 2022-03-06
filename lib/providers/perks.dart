import 'dart:io';

import 'package:flutter/cupertino.dart';

class Perk {}

class Perks with ChangeNotifier {
  List<Perk> _perks = [];

  Future<void> loadPerks() async {
    print("Before sleep");
    sleep(const Duration(seconds: 3));
    print("After sleep");
    _perks.add(Perk());
    notifyListeners();
  }

  int getSize() {
    return _perks.length;
  }
}
