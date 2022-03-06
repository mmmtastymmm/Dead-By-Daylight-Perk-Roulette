import 'package:dbd_perk_picker_flutter/providers/perks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static const routeName = "/main-screen";

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Make sure to load perks on the first time
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<Perks>(context, listen: false).loadPerks();
    });
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
        title: const Text("DBD Picker"),
      ),
      //
      body: Consumer<Perks>(builder: (context, perks, child) {
        Widget listView = const Text("Loading");
        if (perks.getSize() != 0) {
          listView = GridView.extent(
            maxCrossAxisExtent: 160,
            children: perks.getAllPerks(),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
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
