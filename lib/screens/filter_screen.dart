import 'package:dbd_perk_picker_flutter/providers/perks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/perk.dart';

class FilterScreen extends StatefulWidget {
  static const routeName = "/main-screen";

  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  void initState() {
    super.initState();
    // Make sure to load perks on the first time
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> getNewPerks() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter Perks"),
        actions: [
          IconButton(
            onPressed: () =>
                Provider.of<Perks>(context, listen: false).toggleCurrentPerks(),
            icon: const Icon(Icons.repeat),
            tooltip: "Toggle all perks on or off",
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Consumer<Perks>(builder: (context, perks, child) {
        Widget listView = const Text("Loading");
        if (perks.getSize() != 0) {
          listView = GridView.extent(
            maxCrossAxisExtent: Perk.width - 20,
            children: perks.getAllCurrentPerkStates().map((e) {
              var button = ElevatedButton(
                  onPressed: () => {
                        Provider.of<Perks>(context, listen: false)
                            .togglePerk(e.perk)
                      },
                  child: e.perk);
              if (e.enabled) {
                return button;
              } else {
                return Opacity(
                  opacity: 0.35,
                  child: button,
                );
              }
            }).toList(),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            padding: const EdgeInsets.all(20),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(1),
          child: listView,
        );
      }),
    );
  }
}
