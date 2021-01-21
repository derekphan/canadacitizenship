import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cannuck_app_flutter/business_logic/models/history_timeline.dart';
import 'package:cannuck_app_flutter/utilities/constant.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class LearnScreen extends StatefulWidget {
  static const String id = 'learn_screen';

  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  List<HistoryPoint> historyData;

  void _initHistoryData() async {
    String data = await rootBundle.loadString("assets/data/history.json");
    final parsedData = jsonDecode(data).cast<Map<String, dynamic>>();
    List<HistoryPoint> history = parsedData
        .map<HistoryPoint>((item) => HistoryPoint.fromJson(item))
        .toList();
    setState(() {
      historyData = history;
    });
  }

  @override
  void initState() {
    super.initState();
    _initHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    int totalItem = historyData?.length ?? 0;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Discover Canadian History"),
        backgroundColor: learnMainColor,
        textTheme: Theme.of(context).accentTextTheme,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
      ),
      body: Container(
          padding: EdgeInsets.only(left: 5, right: 15),
          child: ListView.builder(
              itemCount: totalItem,
              itemBuilder: (context, index) {
                return TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.08,
                  isFirst: (index == 0 ? true : false),
                  // ignore: null_aware_before_operator
                  isLast: (index == totalItem - 1 ? true : false),
                  endChild: Container(
                      color: Colors.white,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(15.0),
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            historyData[index]?.year,
                            style: Theme.of(context)
                                .accentTextTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 5),
                          Text(
                            historyData[index]?.description,
                            style: Theme.of(context).accentTextTheme.bodyText2,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      )),
                  indicatorStyle: IndicatorStyle(
                    height: 30,
                    width: 30,
                    padding: EdgeInsets.all(5),
                    indicator: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        (historyData[index]?.type == "exploration"
                            ? Icons.explore
                            : (historyData[index]?.type == "government"
                                ? Icons.account_balance
                                : Icons.shield)),
                        color: (historyData[index]?.type == "exploration"
                            ? Colors.lightBlue[800]
                            : (historyData[index]?.type == "government"
                                ? Colors.green[800]
                                : Colors.red[800])),
                        size: 20,
                      ),
                    ),
                  ),
                  beforeLineStyle: LineStyle(thickness: 2, color: Colors.black),
                  afterLineStyle: LineStyle(thickness: 2, color: Colors.black),
                );
              })),
    );
  }
}
