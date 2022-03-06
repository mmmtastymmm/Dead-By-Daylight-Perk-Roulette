import 'package:dbd_perk_picker_flutter/providers/perks.dart';
import 'package:dbd_perk_picker_flutter/screens/main_screen.dart';
import 'package:dbd_perk_picker_flutter/widgets/shift_right_fixer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // This makes providers that the others can query
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => Perks()),
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          fontFamily: "Lato",
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
              .copyWith(secondary: Colors.black),
        ),
        home: const ShiftRightFixer(child: MainScreen()),
        routes: {
          MainScreen.routeName: (context) {
            return const MainScreen();
          },
        },
      ),
    );
  }
}
