#if os(macOS)
import SwiftUI

public protocol FormViewStyle {
    func makeFormBody<Content>(
        @ViewBuilder content: @escaping () -> Content
    ) -> AnyView where Content: View
    
    func makeFormRow<Label, Value>(
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder value: @escaping () -> Value,
        verticalAlignment: VerticalAlignment
    ) -> AnyView where Label: View, Value: View
}

struct FormViewStyleKey: EnvironmentKey {
    static var defaultValue: FormViewStyle {
        HorizontalFormViewStyle()
    }
}

public extension EnvironmentValues {
    var formViewStyle: FormViewStyle {
        get { self[FormViewStyleKey.self] }
        set { self[FormViewStyleKey.self] = newValue }
    }
}

public extension View {
    func formViewStyle(_ style: FormViewStyle) -> some View {
        self.environment(\.formViewStyle, style)
    }
}

#endif
