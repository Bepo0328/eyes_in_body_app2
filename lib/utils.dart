
List<String> mealTime = ['아침', '점심', '저녁', '간식'];
List<String> mealType = ['균형잡힌', '단백질', '탄수화물', '지방', '치팅'];
List<String> wIntense = ['약하게', '적당히', '고강도'];
List<String> wPart = ['유산소', '엉덩이', '복부', '허벅지', '팔', '다리', '가슴', '등', '전신'];

class Utils {
  static String makeTwoDigit(int number) {
    return number.toString().padLeft(2, '0');
  }

  static int getFormTime(DateTime time) {
    return int.parse(
        '${time.year}${makeTwoDigit(time.month)}${makeTwoDigit(time.day)}');
  }

  static DateTime stringToDateTime(String date) {
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(4, 6));
    int day = int.parse(date.substring(6, 8));

    return DateTime(year, month, day);
  }
}
