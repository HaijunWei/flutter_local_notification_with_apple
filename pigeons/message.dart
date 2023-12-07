import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  dartOptions: DartOptions(),
  swiftOut: 'ios/Classes/Messages.g.swift',
  swiftOptions: SwiftOptions(),
  objcOptions: ObjcOptions(prefix: 'HJ'),
))
@HostApi()
abstract class LocalNotificationWithApple {
  /// 添加通知请求
  void add(NotificationRequest request);

  /// 移除指定pengding状态的通知
  void removePendingNotificationRequests(List<String> identifiers);

  /// 移除pengding状态的通知
  void removeAllPendingNotificationRequests();

  /// 获取所有pengding状态的通知
  @async
  List<NotificationRequest> getPendingNotificationRequests();
}

class NotificationRequest {
  NotificationRequest({
    required this.identifier,
    required this.content,
    this.trigger,
  });

  final String identifier;
  final NotificationContent content;
  final NotificationTrigger? trigger;
}

class NotificationContent {
  NotificationContent({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

enum NotificationTriggerType {
  timeInterval,
  dateComponents,
}

class NotificationDateComponents {
  final int? year;
  final int? month;
  final int? day;
  final int? hour;
  final int? minute;
  final int? second;
  final int? weekday;

  NotificationDateComponents({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
    this.weekday,
  });
}

class NotificationTrigger {
  final bool repeats;
  final int? timeInterval;
  final NotificationDateComponents? dateComponents;
  final NotificationTriggerType type;

  NotificationTrigger({
    required this.repeats,
    required this.type,
    this.timeInterval,
    this.dateComponents,
  });
}
