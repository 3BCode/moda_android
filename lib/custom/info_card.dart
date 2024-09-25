import 'package:flutter/material.dart';
import 'package:moda/components/app_color.dart';

// ignore: must_be_immutable
class InfoCard extends StatefulWidget {
  final String text;
  final IconData icon;
  Function onPressed;

  InfoCard({super.key, 
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  // ignore: library_private_types_in_public_api
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            widget.icon,
            color: AppColor.all,
            size: 18.0,
          ),
          title: Text(
            widget.text,
            style: const TextStyle(
              fontFamily: 'MaisonNeue',
              fontSize: 12.0,
              color: Colors.black
            ),
          ),
        ),
      ),
    );
  }
}