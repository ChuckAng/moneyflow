import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:getxfire/getxfire.dart';
import 'package:lottie/lottie.dart';
import 'package:moneyflow/utils/services/db_helper.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  DbHelper dbHelper = DbHelper();
  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpenses = 0;
  String _category = 'Food';
  FaIcon _iconCategory = FaIcon(FontAwesomeIcons.dollarSign);

  List<PieChartSectionData> _pieSection() {
    return List.generate(2, (index) {
      switch (index) {
        case 0:
          return PieChartSectionData(
            color: Colors.green[300],
            value: totalIncome,
            title: 'Income',
            radius: 25,
            titleStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            titlePositionPercentageOffset: 0.6,
          );

        case 1:
          return PieChartSectionData(
            color: Colors.red[300],
            value: totalExpenses,
            title: 'Expenses',
            radius: 25,
            titleStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            titlePositionPercentageOffset: 0.6,
          );

        default:
          throw Error();
      }
    });
  }

  getTotalBalance(Map entireData) {
    totalBalance = 0;
    totalIncome = 0;
    totalExpenses = 0;

    entireData.forEach((key, value) {
      print('val: $value');

      if (value['type'] == 'income') {
        totalBalance += (value['amount'] as double);
        totalIncome += (value['amount'] as double);
      } else {
        totalBalance -= (value['amount'] as double);
        totalExpenses += (value['amount'] as double);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          toolbarHeight: 0.0,
        ),
        floatingActionButton: SpeedDial(
          child: FaIcon(FontAwesomeIcons.ellipsisV),
          openBackgroundColor: Colors.white60,
          openForegroundColor: Colors.black87,
          closedForegroundColor: Colors.grey[900],
          closedBackgroundColor: Colors.grey[800],
          speedDialChildren: [
            SpeedDialChild(
                backgroundColor: Colors.grey[800],
                child: Icon(
                  Icons.add,
                ),
                label: 'Add Income',
                onPressed: () => Get.toNamed('/add-income')),
            SpeedDialChild(
                backgroundColor: Colors.grey[800],
                child: Icon(Icons.remove),
                label: 'Add Expenses',
                onPressed: () => Get.toNamed('/add-expenses'))
          ],
        ),
        body: FutureBuilder<Map>(
            future: dbHelper.fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Unexpected error !',
                      style: TextStyle(color: Colors.white)),
                );
              }

              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LottieBuilder.network(
                          'https://assets2.lottiefiles.com/temp/lf20_dzWAyu.json'),
                      SizedBox(
                        height: 100,
                      ),
                      Text('Start Adding\n\nSome Data Now...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 5,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white30,
                          ))
                    ],
                  );
                }

                getTotalBalance(snapshot.data!);

                return buildHomeUi(size, snapshot);
              } else {
                return Center(
                  child: Text(
                    'Unexpected error!',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            }));
  }

  Widget buildHomeUi(Size size, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
          child: Container(
            height: size.height * .25,
            width: size.width * .85,
            decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(24)),
            child: Container(
              margin: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Balance',
                    style: TextStyle(color: Colors.white60),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.dollarSign,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        '${totalBalance.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Income',
                            style: TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.arrowAltCircleUp,
                                color: Colors.green[200],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 100,
                                child: Text(
                                  '${totalIncome.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Expenses',
                            style: TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.arrowAltCircleDown,
                                color: Colors.red[300],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 100,
                                child: Text(
                                  '${totalExpenses.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
          child: Container(
            margin: EdgeInsets.only(left: 12),
            child: Text(
              'Summary',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 12),
          padding: EdgeInsets.all(50),
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(24),
          ),
          child: PieChart(PieChartData(
              sections: _pieSection(),
              centerSpaceRadius: 50,
              startDegreeOffset: 180)),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  'Transactions',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 23),
                child: Text(
                  'View all',
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w300,
                      fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          reverse: true,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            _category = snapshot.data![index]['category'];
            double inputAmount = snapshot.data![index]['amount'];
            String note = snapshot.data![index]['note'];

            if (note.isEmpty) {
              note = "Opps, empty notes...";
            }

            var _showDate = snapshot.data![index]['date'];
            String formattedDate = DateFormat('d  MMM  y').format(_showDate);

            switch (_category) {
              case 'Netflix':
                _iconCategory = _iconCategory = FaIcon(
                  FontAwesomeIcons.film,
                  color: Colors.white,
                );
                break;

              case 'Shopping':
                _iconCategory = FaIcon(
                  FontAwesomeIcons.shoppingBag,
                  color: Colors.white,
                );
                break;

              default:
                _iconCategory = FaIcon(
                  FontAwesomeIcons.utensils,
                  color: Colors.white,
                );
                break;
            }

            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(left: 30, right: 30, bottom: 25),
                  width: double.infinity,
                  height: 95,
                  decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(25)),
                  child: snapshot.data![index]['type'] == 'income'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.green[300],
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                    child: FaIcon(
                                  FontAwesomeIcons.dollarSign,
                                  color: Colors.white,
                                ))),
                            SizedBox(
                              width: 25,
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              height: 100,
                              width: 100,
                              child: Text('$note',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '+',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        FaIcon(
                                          FontAwesomeIcons.dollarSign,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                        Text(
                                          ' ${inputAmount.toStringAsFixed(2)}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$formattedDate',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.red[300],
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(child: _iconCategory)),
                            SizedBox(
                              width: 25,
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              height: 100,
                              width: 100,
                              child: Text('$note',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '-',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        FaIcon(
                                          FontAwesomeIcons.dollarSign,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                        Text(
                                          ' ${inputAmount.toStringAsFixed(2)}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$formattedDate',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
