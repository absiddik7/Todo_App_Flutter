class Todo {
  static const tableDailyTodo = 'dailyTodo';
  static const String tableWeeklyTodo = 'weeklyTodo';
  static const String tableMonthlyTodo = 'monthlyTodo';

  static const columnId = 'id';
  static const columnTask = 'task';

  Todo({this.id, this.task});

  int? id;
  String? task;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnTask: task};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    task = map[columnTask];
  }
}
