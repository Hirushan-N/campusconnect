import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String = ""
    var backgroundColor: Color
    var textColor: Color
    var borderColor: Color
    var isMultiline: Bool = false

    @ScaledMetric(relativeTo: .body) private var vPad: CGFloat = 12
    @ScaledMetric(relativeTo: .body) private var hPad: CGFloat = 14
    @ScaledMetric(relativeTo: .body) private var cornerRadius: CGFloat = 10
    @ScaledMetric(relativeTo: .body) private var multilineHeight: CGFloat = 200

    var body: some View {
        if isMultiline {
            TextEditor(text: $text)
                .font(.body)
                .padding(EdgeInsets(top: vPad, leading: hPad, bottom: vPad, trailing: hPad))
                .background(backgroundColor)
                .foregroundColor(textColor)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: 1)
                )
                .frame(height: multilineHeight)
                .padding(.horizontal)
                .textInputAutocapitalization(.sentences)
        } else {
            TextField(placeholder, text: $text)
                .font(.body)
                .padding(EdgeInsets(top: vPad, leading: hPad, bottom: vPad, trailing: hPad))
                .background(backgroundColor)
                .foregroundColor(textColor)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: 1)
                )
                .padding(.horizontal)
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled(false)
        }
    }
}

// Preview
struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomTextField(
                text: .constant(""),
                placeholder: "Enter Email",
                backgroundColor: Color(.systemGray6),
                textColor: .primary,
                borderColor: .gray
            )
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Default")

            CustomTextField(
                text: .constant(""),
                placeholder: "Enter Email",
                backgroundColor: Color(.systemGray6),
                textColor: .primary,
                borderColor: .gray
            )
            .environment(\.dynamicTypeSize, .accessibility3)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Large Text")
        }
    }
}
