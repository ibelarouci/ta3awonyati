import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'gqlclient.dart';
import 'constants.dart';
import 'harvest.dart';
import 'navDrawer.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  DashboardScreen({Key key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  Widget getCardItem(dynamic harvestItem) {
    return ExpansionTileCard(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      //elevation: 5.0,
      leading: CircleAvatar(
          radius: 30.0,
          child: Text(harvestItem['harvestDetail']['title'][0],
              style: TextStyle(fontSize: 25))),
      title: Text(harvestItem['harvestDetail']['title'],
          style: TextStyle(fontSize: 30)),
      subtitle: Text(harvestItem['farmHarvest']['title']),
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
                  (harvestItem['harvestQuantity'] != null
                      ? harvestItem['harvestQuantity'].toString()
                      : '')),
              Text("من  :  " +
                  (harvestItem['startDate'] != null
                      ? Constants.getStringDate(
                          int.parse(harvestItem['startDate']))
                      : '')),
              Text("إلى غاية :  " +
                  (harvestItem['harvestDate'] != null
                      ? Constants.getStringDate(
                          int.parse(harvestItem['harvestDate']))
                      : '')),
              Text("دورة الانتاج:  " +
                  (harvestItem['harvestCycle'] != null
                      ? harvestItem['harvestCycle'].toString()
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
                // Navigator.of(context).pushNamed(Harvest.routeName);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Harvest(harvest: harvestItem),
                  ),
                );
                print(
                    "chane farm harvest is done${harvestItem["farmHarvest"]["title"]}");
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
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(title: Text("مشاريع الانتاج")),
            drawer: NavDrawer(),
            body: FutureBuilder<dynamic>(
              future: GqlClient
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
