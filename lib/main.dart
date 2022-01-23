import 'package:eyes_in_body_app2/data/data.dart';
import 'package:eyes_in_body_app2/utils.dart';
import 'package:eyes_in_body_app2/view/body.dart';
import 'package:eyes_in_body_app2/view/food.dart';
import 'package:eyes_in_body_app2/view/workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eyes InBody App',
      theme: ThemeData(
        fontFamily: 'NotoSansKR',
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', 'KR')],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: getPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
                                date: Utils.getFormTime(DateTime.now()),
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
                      },
                      child: const Text('식단'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => WorkoutAddPage(
                              workout: Workout(
                                date: Utils.getFormTime(DateTime.now()),
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
                      },
                      child: const Text('운동'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('몸무게'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => EyeBodyAddPage(
                              eyeBody: EyeBody(
                                date: Utils.getFormTime(DateTime.now()),
                                image: '',
                                memo: '',
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('눈바디'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            currentIndex = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '오늘',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '기록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: '몸무게',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '통계',
          ),
        ],
      ),
    );
  }

  Widget getPage() {
    if (currentIndex == 0) {
      return getHomeWidget(DateTime.now());
    } else {
      return Container();
    }
  }

  Widget getHomeWidget(DateTime date) {
    return Container(
      child: Column(
        children: [
          Container(
            height: cardSize + 20,
            child: ListView.builder(
              itemBuilder: (ctx, idx) {
                return Container(
                  height: cardSize,
                  width: cardSize,
                  color: mainColor,
                );
              },
              itemCount: 3,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Container(
            height: cardSize + 20,
            child: ListView.builder(
              itemBuilder: (ctx, idx) {
                return Container(
                  height: cardSize,
                  width: cardSize,
                  color: mainColor,
                );
              },
              itemCount: 3,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Container(
            height: cardSize + 20,
            child: ListView.builder(
              itemBuilder: (ctx, idx) {
                if (idx == 0) {
                  // 몸무게
                } else {
                  // 눈바디
                }
                return Container(
                  height: cardSize,
                  width: cardSize,
                  color: mainColor,
                );
              },
              itemCount: 2,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}
