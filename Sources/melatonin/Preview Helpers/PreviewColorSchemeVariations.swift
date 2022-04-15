import SwiftUI

public struct PreviewColorSchemeVariations: ViewModifier {
    internal init(_ order: PreviewColorSchemeVariations.Order) {
        switch order {
            case .light:
                self.orderedColorSchemes = [.light]
            case .dark:
                self.orderedColorSchemes = [.dark]
            case .both:
                self.orderedColorSchemes = Self.defaultColorSchemeOrder
            case .bothLightFirst:
                self.orderedColorSchemes = [.light, .dark]
            case .bothDarkFirst:
                self.orderedColorSchemes = [.dark, .light]
        }
    }
    
    static var defaultColorSchemeOrder: [ColorScheme] { [.dark, .light] }
    
    public enum Order {
        case light
        case dark
        case both
        case bothLightFirst
        case bothDarkFirst
    }
    
    let orderedColorSchemes: [ColorScheme]
    
    public func body(content: Content) -> some View {
        Group {
            ForEach(0 ..< orderedColorSchemes.count, id: \.self) {
                content
                    .preferredColorScheme(orderedColorSchemes[$0])
            }
        }
    }
}


public extension View {
    func previewColorSchemeVariations(_ order: PreviewColorSchemeVariations.Order = .both) -> some View {
        self.modifier(PreviewColorSchemeVariations(order))
    }
}
