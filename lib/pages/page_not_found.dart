import 'package:collection_app/pages/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:from_zero_ui/from_zero_ui.dart';


class PageNotFound extends StatefulWidget {

  const PageNotFound({
    Key? key,
  }) : super(key: key);

  @override
  PageNotFoundState createState() => PageNotFoundState();

}

class PageNotFoundState extends State<PageNotFound> {

  @override
  Widget build(BuildContext context) {
    return const ScaffoldMain(
      title: Text('Page Not Found'),
      body: ErrorSign(
        icon: Icon(Icons.broken_image),
        title: 'Page Not Found',
      ),
    );
  }

}
