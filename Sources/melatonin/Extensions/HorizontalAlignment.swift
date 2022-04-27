import SwiftUI

public extension HorizontalAlignment {
    var textAlignment: TextAlignment {
        switch self {
        case .center:
            return .center
        case .trailing:
            return .trailing
        default:
            return .leading
        }
    }
}
