enum TodoItemTag {
  Inbox,
  Work,
  Shopping,
  Family,
  Personal,
}

class TodoItem {
  int id;
  String text;
  DateTime createdDt;
  DateTime dt;
  TodoItemTag? tag;
  bool isDone;
  bool isNotificationScheduled;
  bool? removed;

  TodoItem({
    required this.id,
    required this.text,
    required this.createdDt,
    required this.dt,
    required this.isDone,
    required this.isNotificationScheduled,
    this.tag,
    this.removed,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: int.parse(json['id']),
      text: json['text'],
      createdDt: DateTime.parse(json['createdDt']),
      dt: DateTime.parse(json['dt']),
      tag: json['tag'] != null
          ? TodoItemTag.values.firstWhere((e) => e.toString() == json['tag'])
          : null,
      isDone: json['isDone'],
      isNotificationScheduled: json['isNotificationScheduled'],
      removed: json['removed'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'text': text,
        'createdDt': createdDt.toString(),
        'dt': dt.toString(),
        'tag': tag != null ? tag.toString() : null,
        'isDone': isDone,
        'isNotificationScheduled': isNotificationScheduled,
        'removed': removed,
      };
}
