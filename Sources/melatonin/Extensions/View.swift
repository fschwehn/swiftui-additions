import SwiftUI

public extension View {
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

#if DEBUG
struct View_labelsHidden_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([false, true], id: \.self) { hidden in
            Toggle("The Label", isOn: .constant(true))
                .labelsHidden(hidden)
        }
    }
}
#endif
