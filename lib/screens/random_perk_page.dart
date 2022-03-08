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

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  );
  late final Animation<double> _animation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(_controller);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<Perks>(context, listen: false).loadPerks();
    });
  }

  void getNewPerks() {
    setState(() {
      _perks = Provider.of<Perks>(context, listen: false).getRoulettePerks();
    });
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    var currentModeString =
        prettyPerkType(Provider.of<Perks>(context).getMode());
    if (_perks.isEmpty) {
      getNewPerks();
    }
    _controller.forward();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Dead By Daylight $currentModeString Roulette",
          ),
          foregroundColor: Colors.black,
        ),
        //
        backgroundColor: Colors.black,
        body: Column(
          children: [
            TextButton(
                onPressed: () {
                  Provider.of<Perks>(context, listen: false)
                      .setMode(PerkType.survivor);
                  Navigator.of(context).pushNamed(RandomPerkPage.routeName);
                },
                child: const Text("Filter Perks")),
            TextButton(
                onPressed: () {
                  getNewPerks();
                },
                child: const Text("Reroll")),
            Expanded(
              child: Center(
                child: Row(
                  children: _perks.map((e) {
                    return Expanded(
                      child: FadeTransition(opacity: _animation, child: e),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ));
  }
}
