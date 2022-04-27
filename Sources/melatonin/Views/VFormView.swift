import SwiftUI

public struct VFormView<Content>: View where Content : View {
    private var content: () -> Content
    private var configuration: VFormViewConfiguration
    
    public init(
        alignment: HorizontalAlignment? = nil,
        rowSpacing: CGFloat? = nil,
        labelSpacing: CGFloat? = nil,
        valueLabelsHidden: Bool? = nil,
        labelFont: Font? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.configuration = .init(
            alignment: alignment ?? VFormViewConfiguration.default.alignment,
            rowSpacing: rowSpacing ?? VFormViewConfiguration.default.rowSpacing,
            labelSpacing: labelSpacing ?? VFormViewConfiguration.default.labelSpacing,
            valueLabelsHidden: valueLabelsHidden ?? VFormViewConfiguration.default.valueLabelsHidden,
            labelFont: labelFont ?? VFormViewConfiguration.default.labelFont
        )
        self.content = content
    }
    
    public var body: some View {
        VStack(
            alignment: configuration.alignment,
            spacing: configuration.rowSpacing,
            content: content
        )
        .multilineTextAlignment(configuration.alignment.textAlignment)
        .environment(\.formViewConfiguration, configuration)
    }
}

public struct VFormRow<Label, Value>: View where Label: View, Value: View {
    private var label: () -> Label
    private var value: () -> Value
    
    @Environment(\.formViewConfiguration)
    private var configuration: VFormViewConfiguration
    
    public init(
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder value: @escaping  () -> Value
    ) {
        self.label = label
        self.value = value
    }
    
    public var body: some View {
        VStack(
            alignment: configuration.alignment,
            spacing: configuration.labelSpacing
        ) {
            label()
                .font(configuration.labelFont)
            value()
                .labelsHidden(configuration.valueLabelsHidden)
        }
    }
}

public extension VFormRow where Label == Text {
    init(
        _ label: String,
        @ViewBuilder value: @escaping () -> Value
    ) {
        self.label = { Text(label) }
        self.value = value
    }
}

fileprivate struct VFormViewConfiguration {
    var alignment: HorizontalAlignment
    var rowSpacing: CGFloat
    var labelSpacing: CGFloat
    var valueLabelsHidden: Bool
    var labelFont: Font
    
    static let `default` = Self(
        alignment: HorizontalAlignment.leading,
        rowSpacing: 20,
        labelSpacing: 8,
        valueLabelsHidden: true,
        labelFont: .system(size: 12, weight: .semibold, design: .default)
    )
}

fileprivate struct VFormViewConfigurationKey: EnvironmentKey {
    static var defaultValue: VFormViewConfiguration {
        .default
    }
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
            alignment: .leading,
            rowSpacing: 20,
            labelSpacing: 8,
            valueLabelsHidden: true
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
         
            VFormRow("Toggle") {
                Toggle(isOn: .constant(true), label: EmptyView.init)
            }
            
            VFormRow("Verry long label text may stretch across multiple lines") {
                TextField("value", text: .constant(""))
            }
        }
        .frame(width: 240)
        .padding()
    }
}
#endif

