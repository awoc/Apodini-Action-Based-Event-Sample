public struct Device: Codable {
    public var id: String
    public var type: DeviceType
    public var topics: [String]?
}

public enum DeviceType: String {
    case apns
    case fcm
    case web
}

extension DeviceType: Codable { }
