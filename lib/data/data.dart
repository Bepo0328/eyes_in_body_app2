class Food {
  int? id;
  int date;
  int type;
  int meal;
  int kcal;
  int time;
  String memo;
  String image;

  Food({
    this.id,
    required this.date,
    required this.type,
    required this.meal,
    required this.kcal,
    required this.time,
    required this.memo,
    required this.image,
  });

  factory Food.fromDB(Map<String, dynamic> data) {
    return Food(
      id: data['id'],
      date: data['date'],
      type: data['type'],
      meal: data['meal'],
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
      'meal': meal,
      'kcal': kcal,
      'time': time,
      'memo': memo,
      'image': image,
    };
  }
}

class Workout {
  int? id;
  int date;
  int time;
  int type;
  int distance;
  int kcal;
  int intense;
  int part;
  String name;
  String memo;

  Workout({
    this.id,
    required this.date,
    required this.time,
    required this.type,
    required this.distance,
    required this.kcal,
    required this.intense,
    required this.part,
    required this.name,
    required this.memo,
  });

  factory Workout.fromDB(Map<String, dynamic> data) {
    return Workout(
      id: data['id'],
      date: data['date'],
      time: data['time'],
      type: data['type'],
      distance: data['distance'],
      kcal: data['kcal'],
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
      'type': type,
      'distance': distance,
      'kcal': kcal,
      'intense': intense,
      'part': part,
      'name': name,
      'memo': memo,
    };
  }
}

class EyeBody {
  int? id;
  int date;
  String image;
  String memo;

  EyeBody({
    this.id,
    required this.date,
    required this.image,
    required this.memo,
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
  int date;
  int weight;
  int fat;
  int muscle;

  Weight({
    required this.date,
    required this.weight,
    required this.fat,
    required this.muscle,
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