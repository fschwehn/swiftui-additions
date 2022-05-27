#if os(macOS)
import SwiftUI

public struct FormRow<Label, Value>: View where Label: View, Value: View {
    private var verticalAlignment: VerticalAlignment
    private var label: () -> Label
    private var value: () -> Value
    
    @Environment(\.formViewStyle)
    private var style: FormViewStyle

    public init(
        verticalAlignment: VerticalAlignment = .firstTextBaseline,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder value: @escaping  () -> Value
    ) {
        self.verticalAlignment = verticalAlignment
        self.label = label
        self.value = value
    }
    
    public var body: some View {
        style.makeFormRow(
            label: label,
            value: value,
            verticalAlignment: verticalAlignment
        )
    }
}

public extension FormRow where Label == Text {
    init(
        _ label: String,
        verticalAlignment: VerticalAlignment = .firstTextBaseline,
        @ViewBuilder value: @escaping () -> Value
    ) {
        self.verticalAlignment = verticalAlignment
        self.label = { Text(label + ":") }
        self.value = value
    }
}

#if DEBUG
struct FormRow_Previews: PreviewProvider {
    static let configs: [(previewDisplayName: String, style: FormViewStyle)] = [
        (
            previewDisplayName: "Horizontal default",
            style: .horizontal
        ),
        (
            previewDisplayName: "Vertical default",
            style: .vertical
        ),
    ]
    
    static var previews: some View {
        ForEach(configs, id: \.previewDisplayName) { (previewDisplayName, style) in
            FormRow("Text field") {
                TextField("value", text: .constant(""))
            }
            .previewDisplayName(previewDisplayName)
            .formViewStyle(style)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif

#endif
