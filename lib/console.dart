import 'package:flutter/material.dart';
import './shared_preferences_helper.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'main.dart';
import 'actionserver.dart';

class SendPage extends StatefulWidget {
  SendPage({Key key, this.server}) : super(key: key);
  final Send server;

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  final _sendController = TextEditingController();

  Future postSend() async {
    String _send = await SharedPreferencesHelper.getString("send");
    String _api = await SharedPreferencesHelper.getString("apiKey");
    String _url = await SharedPreferencesHelper.getString("panelUrl");
    var url = 'https://$_url/api/client/servers/${widget.server.id}/command';

    Map data = {'command': '$_send'};
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $_api"
        },
        body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: globals.isDarkTheme ? null : Colors.transparent,
        leading: IconButton(
          color: globals.isDarkTheme ? Colors.white : Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back,
              color: globals.isDarkTheme ? Colors.white : Colors.black),
        ),
        title: Text(DemoLocalizations.of(context).trans('console'),
            style: TextStyle(
                color: globals.isDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700)),
        // actions: <Widget>
        // [
        //   Container
        //   (
        //     margin: EdgeInsets.only(right: 8.0),
        //     child: Row
        //     (
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: <Widget>
        //       [
        //         Text('beclothed.com', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14.0)),
        //         Icon(Icons.arrow_drop_down, color: Colors.black54)
        //       ],
        //     ),
        //   )
        // ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Text(
                  DemoLocalizations.of(context).trans('coming_soon'),
                  style: Theme.of(context).textTheme.headline,
                ),
              ],
            ),
            SizedBox(height: 80.0),
            AccentColorOverride(
              color: Colors.red,
              child: TextField(
                controller: _sendController,
                decoration: InputDecoration(
                  labelText: (DemoLocalizations.of(context)
                      .trans('type_command_here')),
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text(DemoLocalizations.of(context).trans('clear')),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    _sendController.clear();
                  },
                ),
                RaisedButton(
                  child:
                      Text(DemoLocalizations.of(context).trans('send_command')),
                  elevation: 8.0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () async {
                    await SharedPreferencesHelper.setString(
                        "send", _sendController.text);
                    postSend();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        accentColor: color,
        brightness: Brightness.dark,
      ),
    );
  }
}
