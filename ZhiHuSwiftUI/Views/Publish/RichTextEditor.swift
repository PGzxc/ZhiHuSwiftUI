import SwiftUI

struct RichTextEditor: View {
    @Binding var text: String
    @Binding var attributes: [RichText.Attribute]
    @Binding var selectedRange: Range<Int>?
    let onFormatting: () -> Void
    
    var body: some View {
        TextEditor(text: $text)
            .frame(minHeight: 200)
            .overlay(
                GeometryReader { geometry in
                    ForEach(attributes.indices, id: \.self) { index in
                        let attribute = attributes[index]
                        AttributeOverlay(
                            attribute: attribute,
                            textRect: textRect(for: attribute.range, in: geometry)
                        )
                    }
                }
            )
            .onChange(of: text) { _ in
                updateAttributeRanges()
            }
            .onTapGesture {
                selectedRange = getCurrentSelection()
                if selectedRange != nil {
                    onFormatting()
                }
            }
    }
    
    private func textRect(for range: Range<Int>, in geometry: GeometryProxy) -> CGRect {
        // 这里需要实现文本范围到视图坐标的转换
        // 这是一个复杂的实现，可能需要使用 UITextView 作为底层实现
        .zero
    }
    
    private func updateAttributeRanges() {
        // 当文本改变时更新属性范围
        // 这需要处理插入、删除等操作对属性范围的影响
    }
    
    private func getCurrentSelection() -> Range<Int>? {
        // 获取当前选中的文本范围
        // 这需要与底层 UITextView 交互
        nil
    }
}

struct AttributeOverlay: View {
    let attribute: RichText.Attribute
    let textRect: CGRect
    
    var body: some View {
        switch attribute.type {
        case .bold:
            Rectangle()
                .fill(Color.clear)
                .border(Color.blue, width: 1)
                .frame(width: textRect.width, height: textRect.height)
                .position(x: textRect.midX, y: textRect.midY)
        case .link:
            Rectangle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: textRect.width, height: textRect.height)
                .position(x: textRect.midX, y: textRect.midY)
        // ... 其他属性的视觉效果
        default:
            EmptyView()
        }
    }
} 