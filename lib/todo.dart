class ToDo {

  String title = '';
  String date = '';
  String duration = '';

  String get todo_title {
    return title;
  }
  String get todo_date {
    return date;
  }
  String get todo_duration {
    return duration;
  }

  void set todo_title(String title) {
    this.title = title;
  }
  void set todo_date(String date) {
    this.date = date;
  }
  void set todo_duration(String duration) {
    this.duration = duration;
  }


}