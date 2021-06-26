import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'constants.dart';
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
  TextEditingController _tACFarm = TextEditingController();
  SuggestionsBoxController _sBCFarm = SuggestionsBoxController();

  TextEditingController _tACHarvestD = TextEditingController();
  SuggestionsBoxController _sBCHarvestD = SuggestionsBoxController();

  TextEditingController _tACQantity = TextEditingController(text: '0');
  TextEditingController _tACStartDate = TextEditingController();
  TextEditingController _tACHarvestDate = TextEditingController();

  // dynamic selected;

  dynamic farm;
  dynamic harvestDetail;
  DateTime dtStartDate;

  List<dynamic> farms;
  List<dynamic> harvestDetails;
  @override
  void initState() {
    super.initState();
    harvestDetail = Map();
    farm = Map();
    setState(() {
      try {
        harvestDetail["title"] = widget.harvest["harvestDetail"]["title"];
      } catch (e) {}
      try {
        farm["title"] = widget.harvest["farmHarvest"]["title"];
      } catch (e) {}
      try {
        if (widget.harvest["harvestQuantity"] == null)
          _tACQantity.text = '';
        else
          _tACQantity.text = widget.harvest["harvestQuantity"].toString();
      } catch (e) {
        _tACQantity.text = '0';
      }
      try {
        _tACStartDate.text = DateTime.fromMillisecondsSinceEpoch(
                int.parse(widget.harvest["startDate"]))
            .toString();
      } catch (e) {}
      try {
        _tACHarvestDate.text = DateTime.fromMillisecondsSinceEpoch(
                int.parse(widget.harvest["harvestDate"]))
            .toString();
      } catch (e) {}
    });

    GqlClient.getFarmByOwner().then((value) {
      setState(() {
        farms = value;
      });
    });
    GqlClient.getAllHarvestDetails().then((value) => setState(() {
          harvestDetails = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (farm != null) _tACFarm.text = farm["title"];
    if (harvestDetail != null) _tACHarvestD.text = harvestDetail["title"];
    print("startDate${dtStartDate}");
    print("printHarvestDate${_tACHarvestDate.text}");

    return WillPopScope(
        onWillPop: () async {
          print("selected farm${_tACQantity.text}");
          widget.harvest["harvestDetail"]["title"] = harvestDetail["title"];
          widget.harvest["farmHarvest"]["title"] = farm["title"];
          Navigator.pop(context, widget.harvest);
          return true;
        },
        child: Directionality(
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
                                  // print("onchange s$s");

                                  farm = Map();

                                  farm["title"] = s;
                                  print("onchange s${farm["title"]}");

                                  _sBCFarm.open();
                                },
                                onEditingComplete: () {
                                  _sBCFarm.close();
                                },
                                controller: _tACFarm,
                              ),
                              suggestionsCallback: (pattern) async {
                                // print("farm ${GqlClient.getFarmByOwner()}");

                                //l = await GqlClient.getFarmByOwner()
                                //   as List<dynamic>;

                                return farms
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
                                      subtitle:
                                          Text('${suggestion['address']}'),
                                    ));
                              },
                              onSuggestionSelected: (suggestion) {
                                // this._tACFarm.text = suggestion['title']
                                if (suggestion != null)
                                  setState(() {
                                    farm = (suggestion as dynamic);
                                  });
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
                                  harvestDetail = Map();
                                  harvestDetail["title"] = s;
                                  _sBCHarvestD.open();
                                },
                                onEditingComplete: () {
                                  _sBCHarvestD.close();
                                },
                                controller: _tACHarvestD,
                              ),
                              suggestionsCallback: (pattern) async {
                                // print("farm ${GqlClient.getFarmByOwner()}");

                                return harvestDetails
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
                                      subtitle: Text(''),
                                    ));
                              },
                              onSuggestionSelected: (suggestion) {
                                //this._tACHarvestD.text = suggestion['title'];
                                harvestDetail = suggestion;
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
                        // initialValue: "01-03-2015",
                        dateMask: "dd-MM-yyyy",
                        controller: _tACStartDate,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'تاريخ بداية الانتاج',
                        ),
                        firstDate: DateTime(2000, 06, 24),
                        initialDate: DateTime.parse(_tACStartDate.text),
                        lastDate: DateTime(2050, 06, 24),
                      )),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DateTimePicker(
                        //fieldLabelText: ,
                        // initialValue: "2015-01-03 00:00:00.000",
                        dateMask: "dd-MM-yyyy",
                        controller: _tACHarvestDate,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'تاريخ نهاية الانتاج',
                        ),
                        firstDate: DateTime(1900, 06, 24),
                        initialDate: DateTime.parse(_tACHarvestDate.text),
                        lastDate: DateTime(2050, 06, 24),
                      )),
                ]))));
  }
}
