class TodoItem {
  int id;
  String title;
  String text;
  DateTime createdDt;
  DateTime dt;
  bool isDone;
  bool isNotificationScheduled;
  bool? removed;

  TodoItem({
    required this.id,
    required this.title,
    required this.text,
    required this.createdDt,
    required this.dt,
    required this.isDone,
    required this.isNotificationScheduled,
    this.removed,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: int.parse(json['id']),
      title: json['title'],
      text: json['text'],
      createdDt: DateTime.parse(json['createdDt']),
      dt: DateTime.parse(json['dt']),
      isDone: json['isDone'],
      isNotificationScheduled: json['isNotificationScheduled'],
      removed: json['removed'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'title': title,
        'text': text,
        'createdDt': createdDt.toString(),
        'dt': dt.toString(),
        'isDone': isDone,
        'isNotificationScheduled': isNotificationScheduled,
        'removed': removed,
      };
}
