class NotificationItem {
  final String title;
  final String description;
  final String date;
  final String time;

  NotificationItem({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
        title: (json['notificationTitle'] ?? json['title'] ?? '').toString(),
        description:
            (json['notificationDescription'] ?? json['description'] ?? '').toString(),
        date: (json['notificationDate'] ?? json['date'] ?? '').toString(),
        time: (json['notificationTime'] ?? json['time'] ?? '').toString(),
      );
}
