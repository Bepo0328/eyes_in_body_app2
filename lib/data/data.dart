class Food {
  int? id;
  int? date;
  int? type;
  int? kcal;
  int? time;
  String? memo;
  String? image;

  Food({
    this.id,
    this.date,
    this.type,
    this.kcal,
    this.time,
    this.memo,
    this.image,
  });

  factory Food.fromDB(Map<String, dynamic> data) {
    return Food(
      id: data['id'],
      date: data['date'],
      type: data['type'],
      kcal: data['kcal'],
      time: data['time'],
      memo: data['memo'],
      image: data['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'type': type,
      'kcal': kcal,
      'time': time,
      'memo': memo,
      'image': image,
    };
  }
}

class Workout {
  int? id;
  int? date;
  int? time;
  int? calorie;
  int? intense;
  int? part;
  String? name;
  String? memo;

  Workout({
    this.id,
    this.date,
    this.time,
    this.calorie,
    this.intense,
    this.part,
    this.name,
    this.memo,
  });

  factory Workout.fromDB(Map<String, dynamic> data) {
    return Workout(
      id: data['id'],
      date: data['date'],
      time: data['time'],
      calorie: data['calorie'],
      intense: data['intense'],
      part: data['part'],
      name: data['name'],
      memo: data['memo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'calorie': calorie,
      'intense': intense,
      'part': part,
      'name': name,
      'memo': memo,
    };
  }
}

class EyeBody {
  int? id;
  int? date;
  String? image;
  String? memo;

  EyeBody({
    this.id,
    this.date,
    this.image,
    this.memo,
  });

  factory EyeBody.fromDB(Map<String, dynamic> data) {
    return EyeBody(
      id: data['id'],
      date: data['date'],
      image: data['image'],
      memo: data['memo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'image': image,
      'memo': memo,
    };
  }
}

class Weight {
  int? date;
  int? weight;
  int? fat;
  int? muscle;

  Weight({
    this.date,
    this.weight,
    this.fat,
    this.muscle,
  });

  factory Weight.fromDB(Map<String, dynamic> data) {
    return Weight(
      date: data['date'],
      weight: data['weight'],
      fat: data['fat'],
      muscle: data['muscle'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'weight': weight,
      'fat': fat,
      'muscle': muscle,
    };
  }
}