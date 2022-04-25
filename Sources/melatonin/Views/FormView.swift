import SwiftUI

public struct FormView<Content>: View where Content : View {
    private var content: () -> Content
    private var configuration: FormViewConfiguration
    
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

public struct FormRow<Label, Value>: View where Label: View, Value: View {
    private var alignment: VerticalAlignment
    private var label: () -> Label
    private var value: () -> Value
    
    @Environment(\.formViewConfiguration)
    private var configuration: FormViewConfiguration
    
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

extension View {
    @ViewBuilder
    func labelsHidden(_ hidden: Bool) -> some View {
        if hidden {
            self.labelsHidden()
        }
        else {
            self
        }
    }
}

public extension FormRow where Label == Text {
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

fileprivate struct FormViewConfiguration {
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

fileprivate struct FormViewConfigurationKey: EnvironmentKey {
    static let defaultValue = FormViewConfiguration(
        label: .init(),
        value: .init()
    )
}

fileprivate extension EnvironmentValues {
    var formViewConfiguration: FormViewConfiguration {
        get { self[FormViewConfigurationKey.self] }
        set { self[FormViewConfigurationKey.self] = newValue }
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
struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView(
            rowSpacing: 8,
            maxLabelWidth: 140,
            maxValueWidth: 200
        ) {
            FormRow("Label One") {
                TextField("value", text: .constant(""))
            }
            
            FormRow("Label Two") {
                Picker(selection: .constant(1)) {
                    ForEach(1 ... 3, id: \.self) { i in
                        Text("Item \(i)")
                            .tag(i)
                    }
                } label: { EmptyView() }
                    .pickerStyle(.radioGroup)
            }
            
            FormRow {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                    Text("Custom Label")
                }
                .foregroundColor(.red)
            } value: {
                TextField("value", text: .constant(""))
            }
         
            FormRow("Toggle", alignment: .center) {
                Toggle(isOn: .constant(true), label: EmptyView.init)
            }
            
            FormRow("Verry long label text may stretch across multiple lines") {
                TextField("value", text: .constant(""))
            }
            
            FormRow("View without baseline", alignment: .top) {
                Color.gray.frame(height: 40)
            }
        }
        .padding()
    }
}
#endif

