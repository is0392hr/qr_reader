import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../home_page_eng/home_page_eng_widget.dart';
import '../db/db_provider.dart';

class ScorePageEngWidget extends StatefulWidget {
  ScorePageEngWidget({Key key}) : super(key: key);

  @override
  _ScorePageEngWidgetState createState() => _ScorePageEngWidgetState();
}

class _ScorePageEngWidgetState extends State<ScorePageEngWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // added
  List<Widget> _items = <Widget>[];
  @override
  void initState() {
    super.initState();
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFADE3FF),
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePageEngWidget(),
              ),
            );
          },
          child: Icon(
            Icons.home_outlined,
            color: Colors.black,
            size: 24,
          ),
        ),
        title: Text(
          'Your score history',
          style: FlutterFlowTheme.title1.override(
            fontFamily: 'Poppins',
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment(0, 0),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 1,
                    decoration: BoxDecoration(
                      color: Color(0xFFE9E9E9),
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      children: _items,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  // 保存したデータを取り出す
  void getItems() async {
    List<Widget> list = <Widget>[];
    // database_helper.dartのDataBaseHelperをインスタンス化
    final dbProvider = DBProvider.instance;
    Future<List<Map>> result = dbProvider.queryAllRows2();
    List resultList = await result;
    // データの取り出し
    for (Map item in resultList) {
      // 日付操作
      String dateAll = item['created_at'].split(' ')[0];
      String year = dateAll.split('-')[0];
      String month = dateAll.split('-')[1];
      if (month[0] =='0') {
        month = month[1];
      }
      String date = dateAll.split('-')[2];
      if (date[0] =='0') {
        date = date[1];
      }
      dateAll = year + '-' + month + '-' + date;
      String time = item['created_at'].split(' ')[1];
      time = time.split(':')[0] + ':' + time.split(':')[1];
      list.add(
          Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Color(0xFFB7B7B7),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          dateAll,
                          style: FlutterFlowTheme.title2.override(
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        Text(
                          time,
                          style: FlutterFlowTheme.title2.override(
                            fontFamily: 'Montserrat',
                            fontSize: 35,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(1, 0, 15, 0),
                      child: Text(
                        item['score'],
                        textAlign: TextAlign.end,
                        style: FlutterFlowTheme.title1.override(
                          fontFamily: 'Poppins',
                          fontSize: 50,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 25, 15, 0),
                    child: Text(
                      'pt',
                      style: FlutterFlowTheme.bodyText1.override(
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Icon(
                      Icons.share,
                      color: Colors.black,
                      size: 24,
                    ),
                  )
                ],
              ),
            ),
          )
      );
    }
    // ウィジェットの更新
    setState(() {
      _items = list;
    });
  }
}
