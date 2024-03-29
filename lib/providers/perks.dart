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

class PerkStateWrapper {
  final Perk perk;
  bool enabled;

  PerkStateWrapper(this.perk, this.enabled);
}

class Perks with ChangeNotifier {
  final List<PerkStateWrapper> _survivorPerks = [];
  final List<PerkStateWrapper> _killerPerks = [];
  PerkType _currentPerkType = PerkType.killer;

  Future<void> loadPerks() async {
    if (_killerPerks.isNotEmpty && _survivorPerks.isNotEmpty) {
      return;
    }
    // Get the perk table page
    var tableResponse = await http
        .get(Uri.parse("https://deadbydaylight.fandom.com/wiki/Perks"));
    var html = parse(tableResponse.body);
    // Get the two main perk tables, which have this common class name
    var tables = html.body?.getElementsByClassName("wikitable sortable");
    var survivorTable = tables?[0];
    updatePerks(survivorTable, _survivorPerks);
    // Now do the same for killer perks
    var killerTable = tables?[1];
    updatePerks(killerTable, _killerPerks);
    notifyListeners();
  }

  void updatePerks(
      dom.Element? survivorTable, List<PerkStateWrapper> perksToUpdate) {
    // Remove all the old entries
    perksToUpdate.clear();
    List<Perk> perks = [];
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
      perks.add(Perk.parseFromWiki(element));
    }
    // For each perk add an entry
    perksToUpdate.addAll(perks.map((e) => PerkStateWrapper(e, true)));
  }

  int getSize() {
    if (_currentPerkType == PerkType.survivor) {
      return _survivorPerks.length;
    } else {
      return _killerPerks.length;
    }
  }

  List<Perk> getAllCurrentPerks() {
    if (_currentPerkType == PerkType.survivor) {
      return _survivorPerks.map((e) => e.perk).toList();
    } else {
      return _killerPerks.map((e) => e.perk).toList();
    }
  }

  List<PerkStateWrapper> getAllCurrentPerkStates() {
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
      {List<Perk> perksToAvoid = const [],
      int perkCount = 4,
      forceScourgeHook = false,
      forceHexPerk = false,
      forceBoonPerk = false,
      forceExhaustionPerk = false}) {
    if (_currentPerkType == PerkType.survivor) {
      return _getUpToThisManyPerks(_survivorPerks, perkCount,
          perksToAvoid: perksToAvoid,
          forceBoonPerk: forceBoonPerk,
          forceExhaustionPerk: forceExhaustionPerk);
    } else {
      return _getUpToThisManyPerks(_killerPerks, perkCount,
          perksToAvoid: perksToAvoid,
          forceScourgeHook: forceScourgeHook,
          forceHexPerk: forceHexPerk);
    }
  }

  static List<Perk> _getUpToThisManyPerks(List<PerkStateWrapper> perks, int max,
      {List<Perk> perksToAvoid = const [],
      forceScourgeHook = false,
      forceHexPerk = false,
      forceBoonPerk = false,
      forceExhaustionPerk = false}) {
    var randomPerks = perks
        .where((element) =>
            !perksToAvoid.contains(element.perk) && element.enabled)
        .map((e) => e.perk)
        .toList()
      ..shuffle();
    List<Perk> returnPerks = [];
    if (forceScourgeHook &&
        !returnPerks.any((element) => element.isScourgeHook) &&
        randomPerks.any((element) => element.isScourgeHook)) {
      returnPerks.add(randomPerks.firstWhere((element) =>
          element.isScourgeHook && !returnPerks.contains(element)));
    }
    if (forceHexPerk &&
        !returnPerks.any((element) => element.isHex) &&
        randomPerks.any((element) => element.isHex)) {
      returnPerks.add(randomPerks.firstWhere(
          (element) => element.isHex && !returnPerks.contains(element)));
    }

    if (forceBoonPerk &&
        !returnPerks.any((element) => element.isBoon) &&
        randomPerks.any((element) => element.isBoon)) {
      returnPerks.add(randomPerks.firstWhere(
          (element) => element.isBoon && !returnPerks.contains(element)));
    }

    if (forceExhaustionPerk &&
        !returnPerks.any((element) => element.isExhaustion) &&
        randomPerks.any((element) => element.isExhaustion)) {
      returnPerks.add(randomPerks.firstWhere(
          (element) => element.isExhaustion && !returnPerks.contains(element)));
    }

    var index = 0;
    while (returnPerks.length < max && index < randomPerks.length) {
      var perk = randomPerks[index];
      if (!returnPerks.contains(perk)) {
        returnPerks.add(perk);
      }
      index += 1;
    }
    // Shuffle before the end so it looks more random
    return returnPerks..shuffle();
  }

  void disablePerk(Perk perk) {
    if (_survivorPerks.any((element) => element.perk.name == perk.name)) {
      _survivorPerks
          .firstWhere((element) => element.perk.name == perk.name)
          .enabled = false;
    } else if (_killerPerks.any((element) => element.perk.name == perk.name)) {
      _killerPerks
          .firstWhere((element) => element.perk.name == perk.name)
          .enabled = false;
    }
    notifyListeners();
  }

  void enablePerk(Perk perk) {
    if (_survivorPerks.any((element) => element.perk.name == perk.name)) {
      _survivorPerks
          .firstWhere((element) => element.perk.name == perk.name)
          .enabled = true;
    } else if (_killerPerks.any((element) => element.perk.name == perk.name)) {
      _killerPerks
          .firstWhere((element) => element.perk.name == perk.name)
          .enabled = true;
    }
    notifyListeners();
  }

  void togglePerk(Perk perk) {
    if (_survivorPerks.any((element) => element.perk.name == perk.name)) {
      _survivorPerks
              .firstWhere((element) => element.perk.name == perk.name)
              .enabled =
          !_survivorPerks
              .firstWhere((element) => element.perk.name == perk.name)
              .enabled;
    } else if (_killerPerks.any((element) => element.perk.name == perk.name)) {
      _killerPerks
              .firstWhere((element) => element.perk.name == perk.name)
              .enabled =
          !_killerPerks
              .firstWhere((element) => element.perk.name == perk.name)
              .enabled;
    }
    notifyListeners();
  }

  void toggleCurrentPerks() {
    var currentPerks =
        _currentPerkType == PerkType.survivor ? _survivorPerks : _killerPerks;
    var enabledCount = currentPerks
        .map((e) => e.enabled ? 1 : 0)
        .reduce((value, element) => value + element);
    if (enabledCount >= currentPerks.length / 2) {
      for (var perk in currentPerks) {
        perk.enabled = false;
      }
    } else {
      for (var perk in currentPerks) {
        perk.enabled = true;
      }
    }
    notifyListeners();
  }
}
