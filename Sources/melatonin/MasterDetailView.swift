#if os(macOS)

import SwiftUI

public struct MasterDetailView<Item, ItemLabel, DetailView>: View where Item: Identifiable, ItemLabel: View, DetailView: View {
    
    var items: [Item]
    
    @Binding var selection: Item.ID?
    
    var minListWidth: CGFloat?
    var maxListWidth: CGFloat?
    var addItem: (() -> Item.ID)? = nil
    var removeItem: ((_ id: Item.ID) -> Void)? = nil
    var moveItems: ((_ from: IndexSet, _ to: Int) -> Void)? = nil
    var itemLabel: (_ item: Item, _ isActive: Bool) -> ItemLabel
    var detailView: (_ item: Item) -> DetailView
    
    @StateObject private var renderPassCounter = RenderPassCounter()
    
    public init(
        items: [Item],
        selection: Binding<Item.ID?>,
        minListWidth: CGFloat? = nil,
        maxListWidth: CGFloat? = nil,
        addItem: (() -> Item.ID)? = nil,
        removeItem: ((_ id: Item.ID) -> Void)? = nil,
        moveItems: ((_ from: IndexSet, _ to: Int) -> Void)? = nil,
        itemLabel: @escaping (_ item: Item, _ isActive: Bool) -> ItemLabel,
        detailView: @escaping (_ item: Item) -> DetailView
    ) {
        self.items = items
        self._selection = selection
        self.itemLabel = itemLabel
        self.addItem = addItem
        self.removeItem = removeItem
        self.moveItems = moveItems
        self.minListWidth = minListWidth
        self.maxListWidth = maxListWidth
        self.detailView = detailView
    }
    
    public var body: some View {
        renderPassCounter.value += 1
        
        return NavigationView {
            VStack {
                if items.isEmpty {
                    Spacer()
                }
                else {
                    List(content: listContent)
                        .listStyle(SidebarListStyle())
                        .foregroundColor(.primary)
                        .frame(minWidth: minListWidth, maxWidth: maxListWidth)
                }
                
                buttonBox()
                    .padding()
            }
            
            Text("No Selection")
        }
    }
}

private extension MasterDetailView {
    
    class RenderPassCounter: ObservableObject {
        var value = 0
    }
    
    func listContent() -> AnyView {
        let forEach = ForEach(items) { item in
            navigationLink(for: item)
        }
        
        if let moveItems = moveItems {
            return AnyView(forEach.onMove(perform: moveItems))
        }
        else {
            return AnyView(forEach)
        }
    }
    
    func navigationLink(for item: Item) -> some View {
        let renderPass = renderPassCounter.value
        let isActive = item.id == selection
        
        return NavigationLink(
            destination: VStack {
                if selection == item.id {
                    detailView(item)
                    Spacer()
                }
                else {
                    EmptyView()
                }
            },
            isActive: Binding(get: {
                isActive
            }, set: { active in
                if active {
                    selection = item.id
                }
                else if selection == item.id {
                    // A workaround to a strange behavior where the setter fires for the
                    // instance of an old render pass after adding items:
                    if renderPass == renderPassCounter.value {
                        selection = nil
                    }
                }
            }),
            label: {
                itemLabel(item, isActive)
            })
    }
    
    struct ToolButtonLabel: View {
        var imageName: String
        
        var body: some View {
            ZStack {
                Color(white: 0.5, opacity: 0.000_001)
                Image(systemName: imageName)
            }
            .fixedSize(horizontal: true, vertical: false)
        }
    }
    
    func buttonBox() -> some View {
        HStack(alignment: .firstTextBaseline) {
            Spacer()
            Button(action: addButtonAction, label: {
                ToolButtonLabel(imageName: "plus")
            })
            Button(action: removeButtonAction, label: {
                ToolButtonLabel(imageName: "minus")
            })
            .disabled(selection == nil)
        }
        .font(.system(size: 14, weight: Font.Weight.semibold, design: .default))
        .buttonStyle(PlainButtonStyle())
        .fixedSize(horizontal: false, vertical: true)
    }
    
    func addButtonAction() {
        selection = addItem?()
    }
    
    func removeButtonAction() {
        guard let removeItem = removeItem,
              let selection = selection,
              let oldSelectionIndex = items.firstIndex(where: { $0.id == selection })
        else { return }

        removeItem(selection)
        
        let upperIndexBound = items.count - (oldSelectionIndex >= (items.count - 1) ? 2 : 1)
        let newSelectionIndex = min(upperIndexBound, oldSelectionIndex + 1)
        
        if newSelectionIndex >= 0 {
            self.selection = items[newSelectionIndex].id
        }
        else {
            self.selection = nil
        }
    }
    
}

#if DEBUG
struct MasterDetailView_Previews: PreviewProvider {
    struct Item: Identifiable {
        let name: String
        var id: String { name }
    }
    
    static let items: [Item] = [
        .init(name: "One"),
        .init(name: "Two"),
        .init(name: "Three"),
    ]
    
    static var previews: some View {
        MasterDetailView(
            items: items,
            selection: .constant(items[1].id),
            minListWidth: 200,
            maxListWidth: 300) { item, isActive in
                Text(item.name)
                    .font(isActive ? .title2 : .title3)
            } detailView: { item in
                Text(item.name)
            }
    }
}
#endif

#endif
