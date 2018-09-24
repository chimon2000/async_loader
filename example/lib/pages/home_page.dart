import 'package:example/pages/simple_page.dart';
import 'package:flutter/material.dart';
import 'package:example/api.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildTitle('Async Loader Demo'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                child: Text('Simple Example'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SimplePage()),
                  );
                },
              ),
              FlatButton(
                child: Text('Simple Example w/ Error'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SimplePage(
                            fn: getError,
                          ),
                    ),
                  );
                },
              ),
              FlatButton(
                child: Text('Load on Mount Disabled'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SimplePage(
                            title: 'Load on Mount disabled',
                            loadOnMount: false,
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildTitle(String title) {
  return new Padding(
    padding: new EdgeInsets.all(10.0),
    child: new Text(title),
  );
}
