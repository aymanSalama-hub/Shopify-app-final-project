class AppNotification {
  final String title;
  final String body;
  final String date;

  AppNotification({
    required this.title,
    required this.body,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "date": date,
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      title: json["title"],
      body: json["body"],
      date: json["date"],
    );
  }
}
