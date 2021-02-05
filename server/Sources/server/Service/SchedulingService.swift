import Apodini
import Jobs
import Foundation
import Logging

class SchedulingService {
    let scheduler: Scheduler
    let logger: Logger
    
    public var queues: [UUID: KeyPath<KeyPool, WeatherAlert>] = [:]
    var open: [KeyPath<KeyPool, WeatherAlert>] = [\KeyPool.job1, \KeyPool.job2, \KeyPool.job3, \KeyPool.job4, \KeyPool.job5]
    
    init(app: Application) {
        self.scheduler = app.scheduler
        self.logger = app.logger
    }
    
    func add(_ weatherTracker: WeatherTracker) {
        guard let id = weatherTracker.id, open.count > 0 else {
            return
        }
        logger.info("Adding \(weatherTracker.city) \(id)")

        let keyPath = open[0]
        queues[id] = keyPath
        open.remove(at: 0)
        
        let cronTab = parseCronTab(weatherTracker)
        try? scheduler.enqueue(WeatherAlert(tracker: weatherTracker), with: cronTab, keyPath)
    }
    
    func remove(_ weatherTracker: WeatherTracker) {
        guard let id = weatherTracker.id, let keyPath = queues[id] else {
            return
        }
        logger.info("Removing \(weatherTracker.city) \(id)")
        try! scheduler.dequeue(keyPath)

        queues.removeValue(forKey: id)
        open.append(keyPath)
    }
    
    func parseCronTab(_ weatherTracker: WeatherTracker) -> String {
        let date = weatherTracker.date
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)

        switch weatherTracker.notificationInterval {
        case .daily:
            return "\(minutes) \(hour) * * *"
        case .date:
            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)

            return "\(minutes) \(hour) \(day) \(month) *"
        case .weekly:
            return "\(minutes) \(hour) * * \(weatherTracker.dayOfWeek)"
        }
    }
}

// Limiting to 5 jobs at a time
struct KeyPool: EnvironmentAccessible {
    var job1: WeatherAlert
    var job2: WeatherAlert
    var job3: WeatherAlert
    var job4: WeatherAlert
    var job5: WeatherAlert
}

extension Application {
    var schedulingService: SchedulingService {
        if let storedService = self.storage[SchedulingServiceKey.self] {
            return storedService
        }
        let newService = SchedulingService(app: self)
        self.storage[SchedulingServiceKey.self] = newService
        
        return newService
    }
    
    struct SchedulingServiceKey: StorageKey {
        typealias Value = SchedulingService
    }
}
