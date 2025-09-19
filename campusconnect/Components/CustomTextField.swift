//
//  CustomTextField.swift
//  campusconnect
//
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String = ""
    var backgroundColor: Color
    var textColor: Color
    var borderColor: Color
    var isMultiline: Bool = false
    
    var body: some View {
        if isMultiline {
            TextEditor( text: $text)
                .padding()
                .background(backgroundColor)
                .foregroundColor(textColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 1)
                )
                .frame(height: 200)
                .padding(.horizontal)
        } else {
            TextField(placeholder, text: $text)
                .padding()
                .background(backgroundColor)
                .foregroundColor(textColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 1)
                )
                .padding(.horizontal)
        }
    }
}


// Preview
struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(
            text: .constant(""),
            placeholder: "Enter Email",
            backgroundColor: Color(.systemGray6),
            textColor: .black,
            borderColor: .gray
        )
        .previewLayout(.sizeThatFits)
    }
}
