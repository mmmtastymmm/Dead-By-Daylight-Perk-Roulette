import 'package:dbd_perk_picker_flutter/screens/filter_screen.dart';
import 'package:dbd_perk_picker_flutter/widgets/perk_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/perks.dart';
import '../widgets/perk.dart';

class RandomPerkPage extends StatefulWidget {
  static const routeName = '/random-perk-page';

  const RandomPerkPage({Key? key}) : super(key: key);

  @override
  State<RandomPerkPage> createState() => _RandomPerkPageState();
}

class _RandomPerkPageState extends State<RandomPerkPage>
    with TickerProviderStateMixin {
  List<Perk> _perks = [];
  bool _haveScourgeHook = false;
  bool _haveHex = false;

  void setHaveScourgeHook(bool value) {
    setState(() {
      _haveScourgeHook = value;
    });
    _getNewPerks();
  }

  void setHaveHex(bool value) {
    setState(() {
      _haveHex = value;
    });
    _getNewPerks();
  }

  late final List<AnimationController> _controller =
      List<int>.generate(4, (int index) => index)
          .map((_) => AnimationController(
                duration: const Duration(seconds: 4),
                vsync: this,
              ))
          .toList();
  late final List<Animation<double>> _animation =
      List<int>.generate(4, (int index) => index)
          .map((index) => Tween(
                begin: 0.0,
                end: 1.0,
              ).animate(_controller[index]))
          .toList();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<Perks>(context, listen: false).loadPerks();
    });
  }

  void _getNewPerks() {
    setState(() {
      _perks = Provider.of<Perks>(context, listen: false).getRoulettePerks(
          forceHexPerk: _haveHex, forceScourgeHook: _haveScourgeHook);
    });
    for (var controller in _controller) {
      controller.reset();
      controller.forward();
    }
  }

  void _updateSinglePerk(int index) {
    setState(() {
      _perks[index] = Provider.of<Perks>(context, listen: false)
          .getRoulettePerks(perksToAvoid: _perks, perkCount: 1)[0];
    });
    _controller[index].reset();
    _controller[index].forward();
  }

  void _disableAndUpdateSinglePerk(int index) {
    Provider.of<Perks>(context, listen: false).disablePerk(_perks[index]);
    _updateSinglePerk(index);
  }

  @override
  void deactivate() {
    super.deactivate();
    for (var controller in _controller) {
      controller.dispose();
    }
  }

  void _navigateToFilterAndUpdatePerks() async {
    await Navigator.of(context).pushNamed(FilterScreen.routeName);
    _getNewPerks();
  }

  @override
  Widget build(BuildContext context) {
    var currentModeString =
        prettyPerkType(Provider.of<Perks>(context).getMode());
    if (_perks.isEmpty) {
      _getNewPerks();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dead By Daylight $currentModeString Roulette",
        ),
        foregroundColor: Colors.white,
      ),
      //
      backgroundColor: Colors.black,
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                _navigateToFilterAndUpdatePerks();
              },
              child: const Text("Filter Perks")),
          TextButton(
              onPressed: () {
                _getNewPerks();
              },
              child: const Text("Reroll")),
          PerkCheckbox("Include a scourge hook perk", setHaveScourgeHook),
          PerkCheckbox("Include a hex perk", setHaveHex),
          Expanded(
            child: Center(
              child: Row(
                children: _perks.asMap().entries.map((e) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          FadeTransition(
                              opacity: _animation[e.key], child: e.value),
                          TextButton(
                            onPressed: () {
                              _updateSinglePerk(e.key);
                            },
                            child: const Text("Reroll"),
                          ),
                          TextButton(
                            onPressed: () {
                              _disableAndUpdateSinglePerk(e.key);
                            },
                            child: const Text("Disable"),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
