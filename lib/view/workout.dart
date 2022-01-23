import 'package:eyes_in_body_app2/data/data.dart';
import 'package:eyes_in_body_app2/data/database.dart';
import 'package:eyes_in_body_app2/style.dart';
import 'package:eyes_in_body_app2/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutAddPage extends StatefulWidget {
  const WorkoutAddPage({Key? key, required this.workout}) : super(key: key);
  final Workout workout;

  @override
  _WorkoutAddPageState createState() => _WorkoutAddPageState();
}

class _WorkoutAddPageState extends State<WorkoutAddPage> {
  Workout get workout => widget.workout;
  TextEditingController nameController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController calController = TextEditingController();
  TextEditingController distanceController = TextEditingController();

  @override
  void initState() {
    nameController.text = workout.name;
    memoController.text = workout.memo;
    timeController.text = workout.time.toString();
    calController.text = workout.kcal.toString();
    distanceController.text = workout.distance.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: txtColor),
        backgroundColor: bgColor,
        elevation: 0.5,
        actions: [
          TextButton(
            onPressed: () async {
              // 저장하고 종료
              final db = DatabaseHelper.instance;
              workout.name = nameController.text;
              workout.memo = memoController.text;

              if (timeController.text.isEmpty) {
                workout.time = 0;
              } else {
                workout.time = int.parse(timeController.text);
              }

              if (calController.text.isEmpty) {
                workout.kcal = 0;
              } else {
                workout.kcal = int.parse(calController.text);
              }

              if (distanceController.text.isEmpty) {
                workout.distance = 0;
              } else {
                workout.distance = int.parse(distanceController.text);
              }

              await db.insertWorkout(workout);
              Navigator.pop(context);
            },
            child: const Text('저장'),
          ),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (ctx, idx) {
            if (idx == 0) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 70.0,
                      width: 70.0,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            workout.type++;
                            workout.type = workout.type % 4;
                          });
                        },
                        child: Image.asset('assets/img/${workout.type}.png'),
                      ),
                      decoration: BoxDecoration(
                        color: iBgColor,
                        borderRadius: BorderRadius.circular(70.0),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(
                              color: txtColor,
                              width: 0.5,
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
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '운동 시간',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 70.0,
                          child: TextField(
                            controller: timeController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.end,
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
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '소모 칼로리',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 70.0,
                          child: TextField(
                            controller: calController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.end,
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
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '거리',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 70.0,
                          child: TextField(
                            controller: distanceController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.end,
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
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (idx == 2) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '운동 부위',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 2.5,
                      children: List.generate(wPart.length, (_idx) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              workout.part = _idx;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              wPart[_idx],
                              style: TextStyle(
                                color: workout.part == _idx
                                    ? Colors.white
                                    : iTxtColor,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color:
                                  workout.part == _idx ? mainColor : iBgColor,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            } else if (idx == 3) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '운동 강도',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 2.5,
                      children: List.generate(wIntense.length, (_idx) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              workout.intense = _idx;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              wIntense[_idx],
                              style: TextStyle(
                                color: workout.intense == _idx
                                    ? Colors.white
                                    : iTxtColor,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: workout.intense == _idx
                                  ? mainColor
                                  : iBgColor,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            } else if (idx == 4) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '메모',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      controller: memoController,
                      maxLines: 10,
                      minLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: txtColor, width: 0.5),
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
          itemCount: 5,
        ),
      ),
    );
  }
}
