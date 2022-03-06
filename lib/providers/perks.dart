import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../widgets/perk.dart';

class Perks with ChangeNotifier {
  final List<Perk> _perks = [];

  Future<void> loadPerks() async {
    var url = Uri.parse(
        'https://deadbydaylight.fandom.com/wiki/Category:Perk_images');
    var response = await http.get(url);
    var allImages = response.body
        .split(" ")
        .where((element) =>
            element.contains(".png") &&
            element.contains("IconPerks") &&
            element.contains("href") &&
            element.contains("https") &&
            !element.contains("old") &&
            !element.contains("artefactHunter") &&
            !element.contains("toughRunner") &&
            !element.contains("lastStanding"))
        .map((e) {
      return e.split("\"")[1];
    });
    for (var element in allImages) {
      _perks.add(Perk(element));
    }
    notifyListeners();
  }

  int getSize() {
    return _perks.length;
  }

  Perk getByIndex(int index) {
    return _perks[index];
  }

  List<Perk> getAllPerks() {
    return _perks;
  }
}
