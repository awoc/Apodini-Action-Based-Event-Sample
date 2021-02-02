import Apodini
import Notifications
import Logging
import NIO

struct Notifications: Component {
    var content: some Component {
        Group("notifications") {
            Group("device") {
                Register().operation(.create)
                GetAllDevices()
            }
            Group("sample") {
                SendSample()
            }
        }
    }
}

struct Register: Handler {
    @Environment(\.logger) var logger: Logger
    
    @Environment(\.notificationCenter) var notificationCenter: NotificationCenter
    
    @Parameter var device: Device
    
    func handle() -> EventLoopFuture<String> {
        logger.info("Registering device: \(device.id)")
        
        return notificationCenter
                .register(device: device)
                .map {
                    "Successfully Registered"
                }
    }
}

struct GetAllDevices: Handler {
    @Environment(\.logger) var logger: Logger
    
    @Environment(\.notificationCenter) var notificationCenter: NotificationCenter

    
    func handle() -> EventLoopFuture<[Device]> {
        return notificationCenter
            .getAllDevices()
    }
}

//extension Device: Content {}

struct SendSample: Handler {
    @Environment(\.logger) var logger: Logger
    
    @Environment(\.notificationCenter) var notificationCenter: NotificationCenter
    
    func handle() -> EventLoopFuture<String> {
        logger.info("Sending sample notification")
        
        let alert = Alert(title: "Hello", body: "Test Notification")
        return notificationCenter
            .send(notification: .init(alert: alert), to: "general")
            .map {
                "Successfully Sent"
            }
    }
}
