import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/perks.dart';

class RandomPerkPage extends StatefulWidget {
  static const routeName = '/random-perk-page';

  const RandomPerkPage({Key? key}) : super(key: key);

  @override
  State<RandomPerkPage> createState() => _RandomPerkPageState();
}

class _RandomPerkPageState extends State<RandomPerkPage> {
  @override
  Widget build(BuildContext context) {
    var currentModeString =
        prettyPerkType(Provider.of<Perks>(context).getMode());
    return Scaffold(
        appBar: AppBar(
          title: Text("Dead By Daylight $currentModeString Roulette"),
        ),
        //
        body: Text(currentModeString));
  }
}
