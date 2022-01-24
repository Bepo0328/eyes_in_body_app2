import 'package:eyes_in_body_app2/data/data.dart';
import 'package:eyes_in_body_app2/data/database.dart';
import 'package:eyes_in_body_app2/style.dart';
import 'package:eyes_in_body_app2/utils.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class FoodAddPage extends StatefulWidget {
  const FoodAddPage({Key? key, required this.food}) : super(key: key);
  final Food food;

  @override
  _FoodAddPageState createState() => _FoodAddPageState();
}

class _FoodAddPageState extends State<FoodAddPage> {
  Food get food => widget.food;
  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    memoController.text = food.memo;
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
              food.memo = memoController.text;

              await db.insertFood(food);
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
                height: cardSize,
                width: cardSize,
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                child: InkWell(
                  onTap: () {
                    selectImage();
                  },
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Align(
                      child: food.image.isEmpty
                          ? Image.asset('assets/img/food.png')
                          : AssetThumb(
                              asset: Asset(food.image, 'food.png', 0, 0),
                              width: cardSize.toInt(),
                              height: cardSize.toInt(),
                            ),
                    ),
                  ),
                ),
              );
            } else if (idx == 1) {
              String _t = food.time.toString();
              String _m = '';
              String _h = '';

              if (_t.length < 3) {
                _m = _t.substring(0);
                _h = '0';
              } else {
                _m = _t.substring(_t.length - 2);
                _h = _t.substring(0, _t.length - 2);
              }

              TimeOfDay time =
                  TimeOfDay(hour: int.parse(_h), minute: int.parse(_m));

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
                          '식사 시간',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () async {
                            TimeOfDay? _time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (_time == null) {
                              return;
                            }

                            setState(() {
                              food.time = int.parse(
                                  '${_time.hour}${Utils.makeTwoDigit(_time.minute)}');
                            });
                          },
                          child: Text(
                            '${time.hour > 11 ? '오후' : '오전'} '
                            '${Utils.makeTwoDigit(time.hour % 12)}:'
                            '${Utils.makeTwoDigit(time.minute)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
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
                      children: List.generate(mealTime.length, (_idx) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              food.meal = _idx;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              mealTime[_idx],
                              style: TextStyle(
                                color: food.meal == _idx
                                    ? Colors.white
                                    : iTxtColor,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: food.meal == _idx ? mainColor : iBgColor,
                            ),
                          ),
                        );
                      }),
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
                          '식단 평가',
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
                      children: List.generate(mealType.length, (_idx) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              food.type = _idx;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              mealType[_idx],
                              style: TextStyle(
                                color: food.type == _idx
                                    ? Colors.white
                                    : iTxtColor,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: food.type == _idx ? mainColor : iBgColor,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '식단 메모',
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
          itemCount: 4,
        ),
      ),
    );
  }

  Future<void> selectImage() async {
    final _img =
        await MultiImagePicker.pickImages(maxImages: 1, enableCamera: true);

    if (_img.isEmpty) {
      return;
    }

    setState(() {
      food.image = _img.first.identifier!;
    });
  }
}

class MainFoodCard extends StatelessWidget {
  const MainFoodCard({Key? key, required this.food}) : super(key: key);
  final Food food;

  @override
  Widget build(BuildContext context) {
    String _t = food.time.toString();
    String _m = '';
    String _h = '';

    if (_t.length < 3) {
      _m = _t.substring(0);
      _h = '0';
    } else {
      _m = _t.substring(_t.length - 2);
      _h = _t.substring(0, _t.length - 2);
    }

    TimeOfDay time = TimeOfDay(hour: int.parse(_h), minute: int.parse(_m));

    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              Positioned.fill(
                child: AssetThumb(
                  asset: Asset(food.image, 'food.png', 0, 0),
                  width: cardSize.toInt(),
                  height: cardSize.toInt(),
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black38,
                ),
              ),
              Positioned(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${time.hour > 11 ? '오후' : '오전'} '
                    '${Utils.makeTwoDigit(time.hour % 12)}:'
                    '${Utils.makeTwoDigit(time.minute)}',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 6,
                bottom: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 4.0,
                  ),
                  child: Text(
                    mealTime[food.meal],
                    style: const TextStyle(color: Colors.white, fontSize: 14.0,),
                  ),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
