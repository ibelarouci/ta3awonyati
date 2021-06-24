import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'gqlclient.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'navDrawer.dart';

class Harvest extends StatefulWidget {
  dynamic harvest;
  static const routeName = '/harvest';
  Harvest({Key key, @required this.harvest}) : super(key: key);

  @override
  _HarvestState createState() => _HarvestState();
}

class _HarvestState extends State<Harvest> {
  final TextEditingController _tACFarm = TextEditingController();
  final SuggestionsBoxController _sBCFarm = SuggestionsBoxController();

  final TextEditingController _tACHarvestD = TextEditingController();
  final SuggestionsBoxController _sBCHarvestD = SuggestionsBoxController();

  final TextEditingController _tACQantity = TextEditingController();
  dynamic selected;

  List<dynamic> suggestions;
  @override
  void initState() {
    super.initState();
    GqlClient.getFarmByOwner().then((value) {
      setState(() {
        suggestions = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("sugestion$suggestions");

    _tACHarvestD.text = widget.harvest["harvestDetail"]["title"];
    _tACFarm.text = widget.harvest["farmHarvest"]["title"];

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(title: Text("تفاصيل عملية الانتاج")),
            drawer: NavDrawer(),
            body: ListView(children: [
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: TypeAheadField(
                          suggestionsBoxController: _sBCFarm,
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'مزرعة',
                            ),
                            autofocus: false,
                            onTap: () {
                              if (_sBCFarm.isOpened())
                                _sBCFarm.close();
                              else
                                _sBCFarm.open();
                            },
                            onChanged: (s) {
                              _sBCFarm.open();
                            },
                            onEditingComplete: () {
                              _sBCFarm.close();
                            },
                            controller: _tACFarm,
                          ),
                          suggestionsCallback: (pattern) async {
                            // print("farm ${GqlClient.getFarmByOwner()}");
                            List<dynamic> l;

                            l = await GqlClient.getFarmByOwner()
                                as List<dynamic>;

                            return l
                                .where((element) => element['title']
                                    .toString()
                                    .contains(pattern))
                                .toList();
                          },
                          itemBuilder: (context, suggestion) {
                            return Directionality(
                                textDirection: TextDirection.rtl,
                                child: ListTile(
                                  leading: Icon(Icons.shopping_cart),
                                  title: Text(suggestion['title']),
                                  subtitle: Text('${suggestion['address']}'),
                                ));
                          },
                          onSuggestionSelected: (suggestion) {
                            this._tACFarm.text = suggestion['title'];
                          },
                        )),
                      ])),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: TypeAheadField(
                          keepSuggestionsOnLoading: false,
                          suggestionsBoxController: _sBCHarvestD,
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نوع المحصول',
                            ),
                            autofocus: false,
                            onTap: () {
                              if (_sBCHarvestD.isOpened())
                                _sBCHarvestD.close();
                              else
                                _sBCHarvestD.open();
                            },
                            onChanged: (s) {
                              _sBCHarvestD.open();
                            },
                            onEditingComplete: () {
                              _sBCHarvestD.close();
                            },
                            controller: _tACHarvestD,
                          ),
                          suggestionsCallback: (pattern) async {
                            // print("farm ${GqlClient.getFarmByOwner()}");
                            List<dynamic> l;

                            l = await GqlClient.getFarmByOwner()
                                as List<dynamic>;

                            return l
                                .where((element) => element['title']
                                    .toString()
                                    .contains(pattern))
                                .toList();
                          },
                          itemBuilder: (context, suggestion) {
                            return Directionality(
                                textDirection: TextDirection.rtl,
                                child: ListTile(
                                  leading: Icon(Icons.shopping_cart),
                                  title: Text(suggestion['title']),
                                  subtitle: Text('${suggestion['address']}'),
                                ));
                          },
                          onSuggestionSelected: (suggestion) {
                            this._tACHarvestD.text = suggestion['title'];
                          },
                        )),
                      ])),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: TextField(
                            controller: _tACQantity,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'كمية الانتاج المتوقعة',
                            ))),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DateTimePicker(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'تاريخ بداية الانتاج',
                    ),
                    firstDate: DateTime(2020, 06, 24),
                    initialDate: DateTime(2021, 06, 24),
                    lastDate: DateTime(2022, 06, 24),
                  )),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DateTimePicker(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'تاريخ نهاية الانتاج',
                    ),
                    firstDate: DateTime(2020, 06, 24),
                    initialDate: DateTime(2021, 06, 24),
                    lastDate: DateTime(2022, 06, 24),
                  )),
            ])));
  }
}
