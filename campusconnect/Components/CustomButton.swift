import SwiftUI

struct CustomButton: View {
    var title: String
    var backgroundColor: Color
    var textColor: Color
    var action: () -> Void

    @ScaledMetric(relativeTo: .headline) private var fontSize: CGFloat = 18
    @ScaledMetric(relativeTo: .body)     private var vPad: CGFloat = 12
    @ScaledMetric(relativeTo: .body)     private var hPad: CGFloat = 16
    @ScaledMetric(relativeTo: .body)     private var minHeight: CGFloat = 48
    @ScaledMetric(relativeTo: .body)     private var cornerRadius: CGFloat = 10

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize, weight: .bold))
                .foregroundColor(textColor)
                .padding(.vertical, vPad)
                .padding(.horizontal, hPad)
                .frame(maxWidth: .infinity, minHeight: minHeight)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

// Preview
struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomButton(
                title: "Submit",
                backgroundColor: .blue,
                textColor: .white
            ) { print("Button pressed") }
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Default")

            CustomButton(
                title: "Submit",
                backgroundColor: .blue,
                textColor: .white
            ) { }
            .environment(\.dynamicTypeSize, .accessibility3)
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Large Text")
        }
    }
}
