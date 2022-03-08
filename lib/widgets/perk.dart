import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

class Perk extends StatelessWidget {
  static const double width = 200;
  static const double height = 200;
  final String imageUrl;
  final String name;
  final String description;
  final String personOfOrigin;
  final bool isBoon;
  final bool isExhaustion;
  final bool isHex;
  final bool isScourgeHook;

  static Perk parseFromWiki(dom.Element tableRowElement) {
    var name = tableRowElement.children[1].children[0].text;
    var person = tableRowElement.children[3].children[0].text;
    var imageUrl =
        tableRowElement.children[0].children[0].attributes["href"].toString();
    var descriptionList = tableRowElement.children[2].children[2].children;
    var totalDescription = "";
    for (var value in descriptionList) {
      totalDescription += value.text;
    }
    return Perk(
        imageUrl,
        name,
        totalDescription,
        person,
        name.contains("Boon"),
        totalDescription.toLowerCase().contains("exhausted"),
        name.contains("Hex"),
        name.contains("Scourge Hook"));
  }

  const Perk(this.imageUrl, this.name, this.description, this.personOfOrigin,
      this.isBoon, this.isExhaustion, this.isHex, this.isScourgeHook,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(children: [
        Expanded(
          flex: 8,
          child: Image.network(
            imageUrl,
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ]),
    );
  }
}
