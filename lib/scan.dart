import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart' as main;

class MainApp extends StatefulWidget {

  final String place;
  final String way;

  const MainApp({
    Key key,
    @required this.place,
    @required this.way,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState(this.place, this.way);
}

class _QRViewExampleState extends State<MainApp>{

  _QRViewExampleState(String place, String way) {
    this.place = place;
    this.way = way;
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  String place;
  String way;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
            flex: 5,
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    final channel = controller.channel;
    controller.init(qrKey);
    channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case "onRecognizeQR":
          {dynamic arguments = call.arguments;
          check(arguments.toString());
          }
        }
    });
  }

  void check(arguments) async{
    if(arguments != null){
       try{
         DocumentSnapshot data = await Firestore.instance
          .collection('Reserved Data')
          .document(arguments)
          .get();
        print('Pasword: ${data['place']} place: ${this.place}');

        if(data['status'] != 'Cancelled' && data['place'] == this.place){
          if(this.way == 'in' && data['status'] == 'Not Active'){
            Firestore.instance.collection('Reserved Data').document(arguments).updateData({'status': "Activate", 'time-in': DateTime.now()});
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => main.QRViewExample()
                  ));
            return result('Pass');
          }else if(this.way == 'out' && data['status'] == 'Activate'){
            Firestore.instance.collection('Reserved Data').document(arguments).updateData( {'status': "Used" , 'time-out': DateTime.now()});
            result('Pass');
          }else{
            result('Invalid Code');
          }
        }else{
          result('Invalid Code');
        }
      }catch (e){
        result('Invalid Code');
      }
    }
     
    }

  result(var result){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Result"),
            content: Text(
                "$result"),
            actions: <Widget>[
              FlatButton(
                child: Text("ตกลง"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => main.QRViewExample()
                  ));
                },
              ),
            ],
          );
        });
  }
}