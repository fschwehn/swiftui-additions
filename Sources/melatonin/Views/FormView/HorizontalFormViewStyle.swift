#if os(macOS)
import SwiftUI

public struct HorizontalFormViewStyle: FormViewStyle {
    private let rowSpacing: CGFloat?
    private let maxLabelWidth: CGFloat?
    private let maxValueWidth: CGFloat?
    private let valueLabelsHidden: Bool
    
    public init(
        rowSpacing: CGFloat? = nil,
        maxLabelWidth: CGFloat? = 200,
        maxValueWidth: CGFloat? = nil,
        valueLabelsHidden: Bool = true
    ) {
        self.rowSpacing = rowSpacing
        self.valueLabelsHidden = valueLabelsHidden
        self.maxLabelWidth = maxLabelWidth
        self.maxValueWidth = maxValueWidth
    }
    
    public func makeFormBody<Content>(
        content: @escaping () -> Content) -> AnyView where Content : View
    {
        AnyView(
            Grid(alignment: .leading, verticalSpacing: rowSpacing, content: content)
        )
    }
    
    public func makeFormRow<Label, Value>(
        label: @escaping () -> Label,
        value: @escaping () -> Value,
        verticalAlignment: VerticalAlignment
    ) -> AnyView where Label : View, Value : View {
        AnyView(
            GridRow(alignment: verticalAlignment) {
                label()
                    .gridColumnAlignment(.trailing)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: maxLabelWidth, alignment: .trailing)
                value()
                    .labelsHidden(valueLabelsHidden)
                    .frame(maxWidth: maxValueWidth, alignment: .leading)
            }
        )
    }
}

public extension FormViewStyle where Self == HorizontalFormViewStyle {
    static var horizontal: FormViewStyle {
        HorizontalFormViewStyle()
    }
}

#endif
