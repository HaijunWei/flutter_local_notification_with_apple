import Flutter
import UIKit
import NotificationCenter

public class LocalNotificationWithApplePlugin: NSObject, FlutterPlugin, LocalNotificationWithApple {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = LocalNotificationWithApplePlugin()
        LocalNotificationWithAppleSetup.setUp(binaryMessenger: registrar.messenger(), api: instance)
    }
    
    func add(request: NotificationRequest) throws {
        let content = UNMutableNotificationContent()
        content.title = request.content.title
        content.body = request.content.body
        var trigger: UNNotificationTrigger?
        if let t = request.trigger {
            switch (t.type) {
            case .timeInterval:
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(t.timeInterval!), repeats: t.repeats)
            case .dateComponents:
                var dateComponents = DateComponents()
                if let e = t.dateComponents?.year {
                    dateComponents.year = Int(e)
                }
                if let e = t.dateComponents?.month {
                    dateComponents.month = Int(e)
                }
                if let e = t.dateComponents?.day {
                    dateComponents.day = Int(e)
                }
                if let e = t.dateComponents?.hour {
                    dateComponents.hour = Int(e)
                }
                if let e = t.dateComponents?.minute {
                    dateComponents.minute = Int(e)
                }
                if let e = t.dateComponents?.second {
                    dateComponents.second = Int(e)
                }
                if let e = t.dateComponents?.weekday {
                    dateComponents.weekday = Int(e)
                }
                trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: t.repeats)
            }
           
        }
        let req = UNNotificationRequest(identifier: request.identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(req)
    }
    
    func removePendingNotificationRequests(identifiers: [String]) throws {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func removeAllPendingNotificationRequests() throws {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func getPendingNotificationRequests(completion: @escaping (Result<[NotificationRequest], Error>) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            let result = requests.map { NotificationRequest(identifier: $0.identifier, content: NotificationContent(title: $0.content.title, body: $0.content.body)) }
            completion(.success(result))
        })
    }
}
