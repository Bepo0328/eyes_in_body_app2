import 'package:eyes_in_body_app2/data/data.dart';
import 'package:eyes_in_body_app2/data/database.dart';
import 'package:eyes_in_body_app2/style.dart';
import 'package:eyes_in_body_app2/utils.dart';
import 'package:eyes_in_body_app2/view/body.dart';
import 'package:eyes_in_body_app2/view/food.dart';
import 'package:eyes_in_body_app2/view/workout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting().then((value) => runApp(const MyApp()));

  tz.initializeTimeZones();

  const AndroidNotificationChannel androidNotificationChannel =
  AndroidNotificationChannel('bepo', 'Diet App', description: 'Diet App');
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin!
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(androidNotificationChannel);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eyes InBody App',
      theme: ThemeData(
        fontFamily: 'NotoSansKR',
        primarySwatch: mainMColor,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;

  int currentIndex = 0;
  DateTime dateTime = DateTime.now();

  List<Food> foods = [];
  List<Food> allFoods = [];
  List<Workout> workouts = [];
  List<Workout> allWorkouts = [];
  List<EyeBody> eyeBodies = [];
  List<EyeBody> allEyeBodies = [];
  List<Weight> weights = [];
  List<Weight> allWeights = [];

  // ?????? ????????? ??? ?????? ??????
  Future<bool> initNotification() async {
    flutterLocalNotificationsPlugin ??= FlutterLocalNotificationsPlugin();

    var initSettingAndroid = const AndroidInitializationSettings('app_icon');
    var initSettingIOS = const IOSInitializationSettings();

    var initSetting = InitializationSettings(
      android: initSettingAndroid,
      iOS: initSettingIOS,
    );

    await flutterLocalNotificationsPlugin!
        .initialize(initSetting, onSelectNotification: (payload) async {});

    setScheduling();

    return true;
  }

  void getHistories() async {
    int _d = Utils.getFormTime(dateTime);

    foods = await dbHelper.queryFoodByDate(_d);
    allFoods = await dbHelper.queryAllFood();
    workouts = await dbHelper.queryWorkoutByDate(_d);
    allWorkouts = await dbHelper.queryAllWorkout();
    eyeBodies = await dbHelper.queryEyeBodyByDate(_d);
    allEyeBodies = await dbHelper.queryAllEyeBody();
    weights = await dbHelper.queryWeightByDate(_d);
    allWeights = await dbHelper.queryAllWeight();

    if (weights.isNotEmpty) {
      final w = weights.first;
      wCtrl.text = w.weight.toString();
      mCtrl.text = w.muscle.toString();
      fCtrl.text = w.fat.toString();
    } else {
      wCtrl.text = '';
      mCtrl.text = '';
      fCtrl.text = '';
    }

    setState(() {});
  }

  @override
  void initState() {
    getHistories();
    initNotification();
    super.initState();
  }

  void setScheduling() {
    var android = const AndroidNotificationDetails('bepo', 'Diet App',
        channelDescription: 'Diet App',
        importance: Importance.max,
        priority: Priority.max);

    var iOS = const IOSNotificationDetails();

    NotificationDetails detail = NotificationDetails(
      android: android,
      iOS: iOS,
    );

    flutterLocalNotificationsPlugin!.zonedSchedule(
      0,
      '????????? ??????????????? ??????????????????!',
      '?????? ??????????????????!',
      tz.TZDateTime.from(
          DateTime.now().add(const Duration(seconds: 10)), tz.local),
      detail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: 'Diet App',
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(),
      ),
      backgroundColor: bgColor,
      body: getPage(),
      floatingActionButton: ![0, 1].contains(currentIndex)
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  changeToDarkMode();
                });
                // return;
                showModalBottomSheet(
                  context: context,
                  backgroundColor: bgColor,
                  builder: (ctx) {
                    return SizedBox(
                      height: 250.0,
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => FoodAddPage(
                                    food: Food(
                                      date: Utils.getFormTime(dateTime),
                                      type: 0,
                                      meal: 0,
                                      kcal: 0,
                                      time: 1130,
                                      memo: '',
                                      image: '',
                                    ),
                                  ),
                                ),
                              );
                              getHistories();
                            },
                            child: const Text('??????'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => WorkoutAddPage(
                                    workout: Workout(
                                      date: Utils.getFormTime(dateTime),
                                      time: 60,
                                      type: 0,
                                      distance: 0,
                                      kcal: 0,
                                      intense: 0,
                                      part: 0,
                                      name: '',
                                      memo: '',
                                    ),
                                  ),
                                ),
                              );
                              getHistories();
                            },
                            child: const Text('??????'),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('?????????'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => EyeBodyAddPage(
                                    eyeBody: EyeBody(
                                      date: Utils.getFormTime(dateTime),
                                      image: '',
                                      memo: '',
                                    ),
                                  ),
                                ),
                              );
                              getHistories();
                            },
                            child: const Text('?????????'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            currentIndex = idx;
          });
        },
        backgroundColor: bgColor,
        unselectedItemColor: txtColor,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '??????',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '??????',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: '?????????',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '??????',
          ),
        ],
      ),
    );
  }

  Widget getPage() {
    if (currentIndex == 0) {
      return getHomeWidget(DateTime.now());
    } else if (currentIndex == 1) {
      return getHistoryWidget();
    } else if (currentIndex == 2) {
      return getWeightWidget();
    } else if (currentIndex == 3) {
      return getStatisticWidget();
    } else {
      return Container();
    }
  }

  Widget getHomeWidget(DateTime date) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: cardSize,
            child: foods.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset('assets/img/food.png'),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (ctx, idx) {
                      return Container(
                        height: cardSize,
                        width: cardSize,
                        child: MainFoodCard(food: foods[idx]),
                      );
                    },
                    itemCount: foods.length,
                    scrollDirection: Axis.horizontal,
                  ),
          ),
          Container(
            height: cardSize,
            child: workouts.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset('assets/img/workout.png'),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (ctx, idx) {
                      return Container(
                        height: cardSize,
                        width: cardSize,
                        child: MainWorkout(workout: workouts[idx]),
                      );
                    },
                    itemCount: workouts.length,
                    scrollDirection: Axis.horizontal,
                  ),
          ),
          Container(
            height: cardSize,
            child: ListView.builder(
              itemBuilder: (ctx, idx) {
                if (idx == 0) {
                  // ?????????

                  if (weights.isEmpty) {
                    return Container();
                  } else {
                    final w = weights.first;

                    return Container(
                      height: cardSize,
                      width: cardSize,
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        height: cardSize,
                        width: cardSize,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4.0,
                              spreadRadius: 4.0,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '?????????',
                                style: mTs.apply(color: txtColor),
                              ),
                              Text(
                                '${w.weight}kg',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: txtColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  // ?????????
                  if (eyeBodies.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset('assets/img/body.png'),
                      ),
                    );
                  } else {
                    return Container(
                      height: cardSize,
                      width: cardSize,
                      child: MainEyeBodyCard(eyeBody: eyeBodies[0]),
                    );
                  }
                }
              },
              itemCount: 2,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }

  Widget getHistoryWidget() {
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            return Container(
              child: TableCalendar(
                locale: 'ko-KR',
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {CalendarFormat.month: ''},
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: mainColor,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    if (day.weekday == DateTime.sunday) {
                      final text = DateFormat.E().format(day);

                      return Center(
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13.0,
                          ),
                        ),
                      );
                    } else if (day.weekday == DateTime.saturday) {
                      final text = DateFormat.E().format(day);

                      return Center(
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 13.0,
                          ),
                        ),
                      );
                    } else {
                      final text = DateFormat.E().format(day);

                      return Center(
                        child: Text(
                          text,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 13.0),
                        ),
                      );
                    }
                  },
                ),
                focusedDay: dateTime,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                onDaySelected: (selectedDay, focusedDay) {
                  dateTime = selectedDay;
                  getHistories();
                },
                selectedDayPredicate: (day) {
                  return isSameDay(dateTime, day);
                },
              ),
            );
          } else if (idx == 1) {
            return getHomeWidget(dateTime);
          } else {
            return Container();
          }
        },
        itemCount: 2,
      ),
    );
  }

  TextEditingController wCtrl = TextEditingController();
  TextEditingController mCtrl = TextEditingController();
  TextEditingController fCtrl = TextEditingController();
  int chartIndex = 0;

  Widget getWeightWidget() {
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            return Container(
              child: TableCalendar(
                locale: 'ko-KR',
                calendarFormat: CalendarFormat.week,
                availableCalendarFormats: const {CalendarFormat.week: ''},
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                ),
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    if (day.weekday == DateTime.sunday) {
                      final text = DateFormat.E().format(day);

                      return Center(
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13.0,
                          ),
                        ),
                      );
                    } else if (day.weekday == DateTime.saturday) {
                      final text = DateFormat.E().format(day);

                      return Center(
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 13.0,
                          ),
                        ),
                      );
                    } else {
                      final text = DateFormat.E().format(day);

                      return Center(
                        child: Text(
                          text,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 13.0),
                        ),
                      );
                    }
                  },
                ),
                focusedDay: dateTime,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                onDaySelected: (selectedDay, focusedDay) {
                  dateTime = selectedDay;
                  getHistories();
                },
                selectedDayPredicate: (day) {
                  return isSameDay(dateTime, day);
                },
              ),
            );
          } else if (idx == 1) {
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${dateTime.month}??? ${dateTime.day}???',
                        style: mTs.apply(color: txtColor),
                      ),
                      InkWell(
                        onTap: () async {
                          Weight w;
                          if (weights.isEmpty) {
                            w = Weight(
                              date: Utils.getFormTime(dateTime),
                              weight: 0,
                              fat: 0,
                              muscle: 0,
                            );
                          } else {
                            w = weights.first;
                          }

                          w.weight = int.tryParse(wCtrl.text) ?? 0;
                          w.muscle = int.tryParse(mCtrl.text) ?? 0;
                          w.fat = int.tryParse(fCtrl.text) ?? 0;

                          await dbHelper.insertWeight(w);
                          getHistories();
                          FocusScope.of(context).unfocus();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          child: Text(
                            '??????',
                            style: mTs.apply(color: txtColor),
                          ),
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '?????????',
                              style: mTs.apply(color: txtColor),
                            ),
                            TextField(
                              controller: wCtrl,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.end,
                              style: mTs.apply(color: txtColor),
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide(
                                    color: txtColor,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '????????????',
                              style: mTs.apply(color: txtColor),
                            ),
                            TextField(
                              controller: mCtrl,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.end,
                              style: mTs.apply(color: txtColor),
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide(
                                    color: txtColor,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '????????????',
                              style: mTs.apply(color: txtColor),
                            ),
                            TextField(
                              controller: fCtrl,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.end,
                              style: mTs.apply(color: txtColor),
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide(
                                    color: txtColor,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (idx == 2) {
            List<FlSpot> spots = [];

            for (final w in allWeights) {
              if (chartIndex == 0) {
                // ?????????
                spots.add(FlSpot(w.date.toDouble(), w.weight.toDouble()));
              } else if (chartIndex == 1) {
                // ?????????
                spots.add(FlSpot(w.date.toDouble(), w.muscle.toDouble()));
              } else {
                // ?????????
                spots.add(FlSpot(w.date.toDouble(), w.fat.toDouble()));
              }
            }

            return Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          setState(() {
                            chartIndex = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          child: Text(
                            '?????????',
                            style: TextStyle(
                              color: chartIndex == 0 ? Colors.white : iTxtColor,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: chartIndex == 0 ? mainColor : iBgColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            chartIndex = 1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          child: Text(
                            '?????????',
                            style: TextStyle(
                              color: chartIndex == 1 ? Colors.white : iTxtColor,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: chartIndex == 1 ? mainColor : iBgColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            chartIndex = 2;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          child: Text(
                            '?????????',
                            style: TextStyle(
                              color: chartIndex == 2 ? Colors.white : iTxtColor,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: chartIndex == 2 ? mainColor : iBgColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 300.0,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4.0,
                          spreadRadius: 4.0,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(spots: spots, colors: [mainColor]),
                        ],
                        gridData: FlGridData(
                          show: false,
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (spots) {
                              return [
                                LineTooltipItem(
                                  '${spots.first.y}kg',
                                  mTs.apply(color: txtColor),
                                ),
                              ];
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) {
                              return TextStyle(color: txtColor);
                            },
                            getTitles: (value) {
                              DateTime date = Utils.stringToDateTime(
                                  value.toInt().toString());
                              return '${date.day}???';
                            },
                          ),
                          leftTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
        itemCount: 3,
      ),
    );
  }

  Widget getStatisticWidget() {
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            List<FlSpot> spots = [];

            for (final w in allWorkouts) {
              if (chartIndex == 0) {
                // ?????????
                spots.add(FlSpot(w.date.toDouble(), w.time.toDouble()));
              } else if (chartIndex == 1) {
                // ?????????
                spots.add(FlSpot(w.date.toDouble(), w.kcal.toDouble()));
              } else {
                // ?????????
                spots.add(FlSpot(w.date.toDouble(), w.distance.toDouble()));
              }
            }

            return Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          setState(() {
                            chartIndex = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          child: Text(
                            '?????? ??????',
                            style: TextStyle(
                              color: chartIndex == 0 ? Colors.white : iTxtColor,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: chartIndex == 0 ? mainColor : iBgColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            chartIndex = 1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          child: Text(
                            '?????????',
                            style: TextStyle(
                              color: chartIndex == 1 ? Colors.white : iTxtColor,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: chartIndex == 1 ? mainColor : iBgColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            chartIndex = 2;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          child: Text(
                            '??????',
                            style: TextStyle(
                              color: chartIndex == 2 ? Colors.white : iTxtColor,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: chartIndex == 2 ? mainColor : iBgColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 300.0,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4.0,
                          spreadRadius: 4.0,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(spots: spots, colors: [mainColor]),
                        ],
                        gridData: FlGridData(
                          show: false,
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (spots) {
                              return [
                                LineTooltipItem(
                                  '${spots.first.y}',
                                  TextStyle(color: mainColor),
                                ),
                              ];
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTitles: (value) {
                              DateTime date = Utils.stringToDateTime(
                                  value.toInt().toString());
                              return '${date.day}???';
                            },
                          ),
                          leftTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (idx == 1) {
            return Container(
              height: cardSize,
              child: ListView.builder(
                itemBuilder: (ctx, _idx) {
                  return Container(
                    height: cardSize,
                    width: cardSize,
                    child: MainFoodCard(food: allFoods[_idx]),
                  );
                },
                itemCount: allFoods.length,
                scrollDirection: Axis.horizontal,
              ),
            );
          } else if (idx == 2) {
            return Container(
              height: cardSize,
              child: ListView.builder(
                itemBuilder: (ctx, _idx) {
                  return Container(
                    height: cardSize,
                    width: cardSize,
                    child: MainWorkout(workout: allWorkouts[_idx]),
                  );
                },
                itemCount: allWorkouts.length,
                scrollDirection: Axis.horizontal,
              ),
            );
          } else if (idx == 3) {
            return Container(
              height: cardSize,
              child: ListView.builder(
                itemBuilder: (ctx, _idx) {
                  return Container(
                    height: cardSize,
                    width: cardSize,
                    child: MainEyeBodyCard(eyeBody: allEyeBodies[_idx]),
                  );
                },
                itemCount: allEyeBodies.length,
                scrollDirection: Axis.horizontal,
              ),
            );
          } else {
            return Container();
          }
        },
        itemCount: 4,
      ),
    );
  }
}
