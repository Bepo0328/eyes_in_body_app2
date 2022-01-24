import 'package:eyes_in_body_app2/data/data.dart';
import 'package:eyes_in_body_app2/data/database.dart';
import 'package:eyes_in_body_app2/style.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class EyeBodyAddPage extends StatefulWidget {
  const EyeBodyAddPage({Key? key, required this.eyeBody}) : super(key: key);
  final EyeBody eyeBody;

  @override
  _EyeBodyAddPageState createState() => _EyeBodyAddPageState();
}

class _EyeBodyAddPageState extends State<EyeBodyAddPage> {
  EyeBody get eyeBody => widget.eyeBody;
  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    memoController.text = eyeBody.memo;
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
              eyeBody.memo = memoController.text;

              await db.insertEyeBody(eyeBody);
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
                      child: eyeBody.image.isEmpty
                          ? Image.asset('assets/img/body.png')
                          : AssetThumb(
                              asset: Asset(eyeBody.image, 'body.png', 0, 0),
                              width: cardSize.toInt(),
                              height: cardSize.toInt(),
                            ),
                    ),
                  ),
                ),
              );
            } else if (idx == 1) {
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
          itemCount: 2,
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
      eyeBody.image = _img.first.identifier!;
    });
  }
}

class MainEyeBodyCard extends StatelessWidget {
  const MainEyeBodyCard({Key? key, required this.eyeBody}) : super(key: key);
  final EyeBody eyeBody;

  @override
  Widget build(BuildContext context) {
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
                  asset: Asset(eyeBody.image, 'food.png', 0, 0),
                  width: cardSize.toInt(),
                  height: cardSize.toInt(),
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}