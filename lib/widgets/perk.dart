import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class Perk extends StatelessWidget {
  final String _imageUrl;
  late String name;

  Perk(this._imageUrl, {Key? key}) : super(key: key) {
    name = _imageUrl.split("_").last.split(".").first;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Column(children: [
        Expanded(
          flex: 8,
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: _imageUrl,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            name,
            textAlign: TextAlign.center,
          ),
        ),
      ]),
    );
  }
}
