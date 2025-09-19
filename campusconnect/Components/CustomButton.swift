//
//  CustomButton.swift
//  campusconnect
//
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var backgroundColor: Color
    var textColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(textColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(10)
        }
    }
}

// Preview
struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(
            title: "Submit",
            backgroundColor: Color.blue,
            textColor: Color.white
        ) {
            print("Button pressed")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
