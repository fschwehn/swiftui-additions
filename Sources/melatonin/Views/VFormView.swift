import SwiftUI

public struct VFormView<Content>: View where Content : View {
    private var content: () -> Content
    private var configuration: VFormViewConfiguration
    
    public init(
        rowSpacing: CGFloat? = 8,
        maxLabelWidth: CGFloat? = nil,
        maxValueWidth: CGFloat? = nil,
        valueLabelsHidden: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.configuration = .init(
            rowSpacing: rowSpacing,
            label: .init(
                maxWidth: maxLabelWidth
            ),
            value: .init(
                maxWidth: maxValueWidth,
                labelsHidden: valueLabelsHidden
            )
        )
        self.content = content
    }
    
    public var body: some View {
        VStack(
            alignment: .label,
            spacing: configuration.rowSpacing,
            content: content
        )
        .environment(\.formViewConfiguration, configuration)
    }
}

public struct VFormRow<Label, Value>: View where Label: View, Value: View {
    private var alignment: VerticalAlignment
    private var label: () -> Label
    private var value: () -> Value
    
    @Environment(\.formViewConfiguration)
    private var configuration: VFormViewConfiguration
    
    public init(
        alignment: VerticalAlignment = .firstTextBaseline,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder value: @escaping  () -> Value
    ) {
        self.alignment = alignment
        self.label = label
        self.value = value
    }
    
    public var body: some View {
        HStack(alignment: alignment, spacing: nil) {
            label()
                .multilineTextAlignment(.trailing)
                .frame(
                    maxWidth: configuration.label.maxWidth,
                    alignment: .trailing
                )
                .alignmentGuide(.label, computeValue: { $0[.label] })
            value()
                .labelsHidden(configuration.value.labelsHidden)
                .frame(
                    maxWidth: configuration.value.maxWidth,
                    alignment: .leading
                )
        }
    }
}

public extension VFormRow where Label == Text {
    init(
        _ label: String,
        alignment: VerticalAlignment = .firstTextBaseline,
        @ViewBuilder value: @escaping () -> Value
    ) {
        self.alignment = alignment
        self.label = { Text(label) }
        self.value = value
    }
}

fileprivate struct VFormViewConfiguration {
    struct Label {
        var maxWidth: CGFloat?
    }
    
    struct Value {
        var maxWidth: CGFloat?
        var labelsHidden: Bool = true
    }
    
    var rowSpacing: CGFloat?
    var label: Label
    var value: Value
}

fileprivate struct VFormViewConfigurationKey: EnvironmentKey {
    static let defaultValue = VFormViewConfiguration(
        label: .init(),
        value: .init()
    )
}

fileprivate extension EnvironmentValues {
    var formViewConfiguration: VFormViewConfiguration {
        get { self[VFormViewConfigurationKey.self] }
        set { self[VFormViewConfigurationKey.self] = newValue }
    }
}

fileprivate extension HorizontalAlignment {
    struct LabelAlignment: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[HorizontalAlignment.trailing]
        }
    }
    
    static let label = HorizontalAlignment(LabelAlignment.self)
}

#if DEBUG
struct VFormView_Previews: PreviewProvider {
    static var previews: some View {
        VFormView(
            rowSpacing: 8,
            maxLabelWidth: 140,
            maxValueWidth: 200
        ) {
            VFormRow("Label One") {
                TextField("value", text: .constant(""))
            }
            
            VFormRow("Label Two") {
                Picker(selection: .constant(1)) {
                    ForEach(1 ... 3, id: \.self) { i in
                        Text("Item \(i)")
                            .tag(i)
                    }
                } label: { EmptyView() }
                    .pickerStyle(.radioGroup)
            }
            
            VFormRow {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                    Text("Custom Label")
                }
                .foregroundColor(.red)
            } value: {
                TextField("value", text: .constant(""))
            }
         
            VFormRow("Toggle", alignment: .center) {
                Toggle(isOn: .constant(true), label: EmptyView.init)
            }
            
            VFormRow("Verry long label text may stretch across multiple lines") {
                TextField("value", text: .constant(""))
            }
            
            VFormRow("View without baseline", alignment: .top) {
                Color.gray.frame(height: 40)
            }
        }
        .padding()
    }
}
#endif

