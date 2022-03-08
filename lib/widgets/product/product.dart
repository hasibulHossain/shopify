import 'package:flutter/material.dart';

class Product extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  const Product({
    Key? key,
    required this.id,
    required this.title,
    required this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imgUrl),
          ),
          title: Text(title),
          trailing: Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
