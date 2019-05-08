import 'package:flutter/material.dart';
import 'scan.dart' as scan;


void main() => runApp(MaterialApp(home: QRViewExample()));

class QRViewExample extends StatefulWidget {
  const QRViewExample({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample>{
  var selected;
  var selected2;
  var value;
  List<DropdownMenuItem<String>> item = [new DropdownMenuItem(child: Text('central bangna'), value: 'central bangna')
  , new DropdownMenuItem(child: Text('mega'), value: 'mega'), new DropdownMenuItem(child: Text('siam'), value: 'siam')];
  List<DropdownMenuItem<String>> item2 = [new DropdownMenuItem(child: Text('in'), value: 'in')
  , new DropdownMenuItem(child: Text('out'), value: 'out')];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar :new AppBar(
        title: new Text("Scaner"),
      ),
      body: Container(
        child : Padding(
          padding: EdgeInsets.only(top: 215.0, left: 80.0),
          child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
              DropdownButton(
              value: selected,
              items: item,
              hint: new Text("Select place"),
              onChanged: (value){
                selected = value;
                setState(() {
                  
                });
                print('Your value : $value');
                },
            ),Padding(
                padding: EdgeInsets.only(left: 20.0),
                child:DropdownButton(
                  value: selected2,
                  items: item2,
                  hint: new Text("Select place"),
                  onChanged: (value){
                    selected2 = value;
                    setState(() {
                      
                    });
                    print('Your value : $value');
                    },
                  )
                )
              ]
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, right: 90.0),
              child:IconButton(
                icon: Icon(Icons.camera_alt),
                tooltip: 'Go to scanner ',
                iconSize: 50,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => scan.MainApp(place: selected, way: selected2,)
                  ));
                },
              ),
            )
            ],
          )
        )
      )
    );
  }
}