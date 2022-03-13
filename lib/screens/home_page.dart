import 'package:dbd_perk_picker_flutter/screens/random_perk_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/perks.dart';

class HomePage extends StatelessWidget {
  static const routeName = "/home";

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dead By Daylight Roulette",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      //
      body: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  Provider.of<Perks>(context, listen: false)
                      .setMode(PerkType.survivor);
                  Navigator.of(context).pushNamed(RandomPerkPage.routeName);
                },
                child: const Text("Survivor")),
            TextButton(
                onPressed: () {
                  Provider.of<Perks>(context, listen: false)
                      .setMode(PerkType.killer);
                  Navigator.of(context).pushNamed(RandomPerkPage.routeName);
                },
                child: const Text("Killer"))
          ],
        ),
      ),
    );
  }
}
