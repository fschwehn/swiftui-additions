#if os(macOS)
import SwiftUI

public struct VerticalFormViewStyle: FormViewStyle {
    private let rowSpacing: CGFloat?
    private let labelSpacing: CGFloat?
    private let valueLabelsHidden: Bool
    
    public init(
        rowSpacing: CGFloat? = 20,
        labelSpacing: CGFloat? = 6,
        valueLabelsHidden: Bool = true
    ) {
        self.rowSpacing = rowSpacing
        self.labelSpacing = labelSpacing
        self.valueLabelsHidden = valueLabelsHidden
    }
    
    public func makeFormBody<Content>(
        content: @escaping () -> Content
    ) -> AnyView where Content : View {
        AnyView(
            VStack(
                alignment: .leading,
                spacing: rowSpacing,
                content: content
            )
        )
    }
    
    public func makeFormRow<Label, Value>(
        label: @escaping () -> Label,
        value: @escaping () -> Value,
        verticalAlignment: VerticalAlignment
    ) -> AnyView where Label : View, Value: View {
        AnyView(
            VStack(alignment: .leading, spacing: labelSpacing) {
                label()
                value()
                    .labelsHidden(valueLabelsHidden)
            }
        )
    }
}

public extension FormViewStyle where Self == VerticalFormViewStyle {
    static var vertical: FormViewStyle {
        VerticalFormViewStyle()
    }
}

#endif
