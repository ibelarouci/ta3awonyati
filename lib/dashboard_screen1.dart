import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'gqlclient.dart';
import 'constants.dart';
import 'harvest.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  DashboardScreen({Key key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  Widget getCardItem(dynamic harvestlist) {
    return ExpansionTileCard(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      //elevation: 5.0,
      leading: CircleAvatar(
          radius: 30.0,
          child: Text(harvestlist['harvestDetail']['title'][0],
              style: TextStyle(fontSize: 25))),
      title: Text(harvestlist['harvestDetail']['title'],
          style: TextStyle(fontSize: 30)),
      subtitle: Text(harvestlist['farmHarvest']['title']),
      children: <Widget>[
        Divider(
          thickness: 1.0,
          height: 1.0,
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("الكمية :  " +
                  (harvestlist['harvestQuantity'] != null
                      ? harvestlist['harvestQuantity'].toString()
                      : '')),
              Text("من  :  " +
                  (harvestlist['startDate'] != null
                      ? Constants.getStringDate(
                          int.parse(harvestlist['startDate']))
                      : '')),
              Text("إلى غاية :  " +
                  (harvestlist['harvestDate'] != null
                      ? Constants.getStringDate(
                          int.parse(harvestlist['harvestDate']))
                      : '')),
              Text("دورة الانتاج:  " +
                  (harvestlist['harvestCycle'] != null
                      ? harvestlist['harvestCycle'].toString()
                      : '')),
            ],
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.end,
          buttonHeight: 52.0,
          buttonMinWidth: 90.0,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Harvest.routeName);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.description),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text('التفاصيل ... '),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    GqlClient client1 = GqlClient();

    return Scaffold(
        body: Directionality(
            textDirection: TextDirection.rtl,
            child: FutureBuilder<dynamic>(
              future: client1
                  .getHarvestByOwner(), // a previously-obtained Future<String> or null
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return getCardItem(snapshot.data[index]);
                      });
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    )
                  ];
                } else {
                  children = const <Widget>[
                    SizedBox(
                      child: CircularProgressIndicator(),
                      width: 60,
                      height: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting result...'),
                    )
                  ];
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            )));
  }
}
