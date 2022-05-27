#if os(macOS)
import SwiftUI

public struct FormView<Content>: View where Content : View {
    private var content: () -> Content
    
    @Environment(\.formViewStyle)
    private var style
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        style.makeFormBody(content: content)
    }
}

#if DEBUG
struct FormView_Previews: PreviewProvider {
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
            FormView {
                FormRow("Text field") {
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
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("Custom Label:")
                    }
                    .foregroundColor(.red)
                } value: {
                    TextField("value", text: .constant(""))
                }
                
                FormRow("Toggle", verticalAlignment: .center) {
                    Toggle(isOn: .constant(true), label: EmptyView.init)
                }
                
                FormRow("Very long label text may stretch across multiple lines") {
                    TextField("value", text: .constant(""))
                }
                
                FormRow("View without baseline", verticalAlignment: .top) {
                    Color.gray.frame(height: 40)
                }
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
