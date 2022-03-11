import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

import '../widgets/perk.dart';

enum PerkType { survivor, killer }

String prettyPerkType(PerkType perkType) {
  switch (perkType) {
    case PerkType.survivor:
      return "Survivor";

    case PerkType.killer:
      return "Killer";
  }
}

class Perks with ChangeNotifier {
  final List<Perk> _survivorPerks = [];
  final List<Perk> _killerPerks = [];
  PerkType _currentPerkType = PerkType.killer;

  Future<void> loadPerks() async {
    // Get the perk table page
    var tableResponse = await http
        .get(Uri.parse("https://deadbydaylight.fandom.com/wiki/Perks"));
    var html = parse(tableResponse.body);
    // Get the two main perk tables, which have this common class name
    var tables = html.body?.getElementsByClassName("wikitable unknownClass");
    var survivorTable = tables?[0];
    updatePerks(survivorTable, _survivorPerks);
    // Now do the same for killer perks
    var killerTable = tables?[1];
    updatePerks(killerTable, _killerPerks);
    notifyListeners();
  }

  void updatePerks(dom.Element? survivorTable, List<Perk> listToUpdate) {
    // Get the rows and filter out the header
    var allRows = survivorTable?.children.last.children;
    var allRowsSize = allRows?.length;
    List<dom.Element> goodRows = [];
    for (var i = 0; i < allRowsSize!; i++) {
      if (i != 0) {
        var value = allRows?.elementAt(i);
        if (value != null) {
          goodRows.add(value);
        }
      }
    }
    // Now update the perks
    for (var element in goodRows) {
      listToUpdate.add(Perk.parseFromWiki(element));
    }
  }

  int getSize() {
    if (_currentPerkType == PerkType.survivor) {
      return _survivorPerks.length;
    } else {
      return _killerPerks.length;
    }
  }

  Perk getByIndex(int index) {
    if (_currentPerkType == PerkType.survivor) {
      return _survivorPerks[index];
    } else {
      return _killerPerks[index];
    }
  }

  List<Perk> getAllCurrentPerks() {
    if (_currentPerkType == PerkType.survivor) {
      return _survivorPerks;
    } else {
      return _killerPerks;
    }
  }

  void setMode(PerkType newPerkType) {
    _currentPerkType = newPerkType;
  }

  PerkType getMode() {
    return _currentPerkType;
  }

  List<Perk> getRoulettePerks(
      {List<Perk> perksToAvoid = const [], int perkCount = 4}) {
    if (_currentPerkType == PerkType.survivor) {
      return _getUpToThisManyPerks(_survivorPerks, 4,
          perksToAvoid: perksToAvoid);
    } else {
      return _getUpToThisManyPerks(_killerPerks, 4, perksToAvoid: perksToAvoid);
    }
  }

  static List<Perk> _getUpToThisManyPerks(List<Perk> perks, int max,
      {List<Perk> perksToAvoid = const []}) {
    var randomPerks = perks
        .where((element) => !perksToAvoid.contains(element))
        .toList()
      ..shuffle();
    return randomPerks.sublist(0, min(max, perks.length)).toList();
  }
}
