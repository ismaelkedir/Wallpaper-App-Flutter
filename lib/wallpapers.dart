import 'dart:convert';
import 'global.dart';
import 'models/photos.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Wallpaper extends StatefulWidget {
  @override
  _WallpaperState createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  getWallpaper() async {
    await http.get("https://api.pexels.com/v1/search?query=people", headers: {
      "Authorization":
          "PEXELS_API_KEY"
    }).then((res) {
      // print(res.body);
      var parsedJson = jsonDecode(res.body);
      Global.photos =
          (parsedJson["photos"] as List).map((data) => Photos.fromJson(data)).toList();
    });
    setState(() {});
  }

  @override
  void initState() {
    getWallpaper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: Global.photos.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 0.8),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Global.index = index;
              Navigator.of(context).pushNamed('FullImage');
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(Global.photos[index].src.tiny),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
