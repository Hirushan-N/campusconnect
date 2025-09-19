import SwiftUI

struct RegisterToCommunityView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var year: String = ""
    @State private var semester: String = ""
    @State private var aboutYourself: String = ""
    @State private var selectedSkills: [String] = []
    @State private var showSuccessAlert = false

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let skills = ["Swift", "Java", "Python", "C++", "UI/UX Design"]
    private let getFormWebhookURL = "https://getform.io/f/arogpzlb"

    @ScaledMetric(relativeTo: .body) private var fieldPadding: CGFloat = 12
    @ScaledMetric(relativeTo: .body) private var cornerRadius: CGFloat = 8

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // MARK: - Name
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Full Name")
                            .font(.headline)                // Dynamic Type
                            .accessibilityAddTraits(.isHeader)

                        TextField("Enter Name", text: $name)
                            .textContentType(.name)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled(false)
                            .padding(fieldPadding)
                            .background(RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(Color.gray, lineWidth: 1))
                            .accessibilityLabel("Full name")
                            .accessibilityHint("Enter your full name")
                    }

                    // MARK: - Email
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.headline)

                        TextField("Enter Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .padding(fieldPadding)
                            .background(RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(Color.gray, lineWidth: 1))
                            .accessibilityLabel("Email address")
                            .accessibilityHint("Enter a valid email address")
                    }

                    // MARK: - Year
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Year")
                            .font(.headline)

                        TextField("Enter Year", text: $year)
                            .keyboardType(.numberPad)
                            .textContentType(.oneTimeCode) // avoids auto-fill oddities; numeric keyboard
                            .padding(fieldPadding)
                            .background(RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(Color.gray, lineWidth: 1))
                            .accessibilityLabel("Academic year")
                            .accessibilityHint("Enter your current academic year")
                    }

                    // MARK: - Semester
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Semester")
                            .font(.headline)

                        TextField("Enter Semester", text: $semester)
                            .keyboardType(.numberPad)
                            .textContentType(.oneTimeCode)
                            .padding(fieldPadding)
                            .background(RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(Color.gray, lineWidth: 1))
                            .accessibilityLabel("Semester")
                            .accessibilityHint("Enter your current semester")
                    }

                    // MARK: - About Yourself
                    VStack(alignment: .leading, spacing: 6) {
                        Text("About Yourself")
                            .font(.headline)

                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $aboutYourself)
                                .frame(minHeight: 150)
                                .padding(8)
                                .background(RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(Color.gray, lineWidth: 1))
                                .accessibilityLabel("About yourself")
                                .accessibilityHint("Describe yourself briefly")

                            if aboutYourself.isEmpty {
                                Text("Tell Us About Yourself")
                                    .foregroundColor(.gray)
                                    .padding(.top, 14)
                                    .padding(.leading, 16)
                                    .allowsHitTesting(false)
                                    .accessibilityHidden(true)
                            }
                        }
                    }

                    // MARK: - Skills
                    Text("Select Skills")
                        .font(.headline)
                        .padding(.top, 4)
                        .accessibilityAddTraits(.isHeader)

                    MultiSelectPicker(skills: skills, selectedSkills: $selectedSkills)
                        .padding(.vertical)

                    // MARK: - Submit
                    Button(action: {
                        submitForm()
                    }) {
                        Text("Submit")
                            .font(.headline)            // Dynamic Type
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, fieldPadding)
                            .contentShape(Rectangle())
                    }
                    .background(Color.blue)
                    .cornerRadius(10)
                    .accessibilityLabel("Submit application")
                    .accessibilityHint("Sends your application to the community")
                    .accessibilityIdentifier("submitButton")
                }
                .padding()
                .dynamicTypeSize(.small ... .accessibility5)
            }
            .navigationTitle("Member Application")
            .alert(isPresented: $showSuccessAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text("Your application was submitted!"),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }

    // MARK: - Networking
    func submitForm() {
        let formData: [String: Any] = [
            "name": name,
            "email": email,
            "year": year,
            "semester": semester,
            "aboutYourself": aboutYourself,
            "skills": selectedSkills.joined(separator: ", ")
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: formData) else {
            print("Error serializing form data to JSON")
            return
        }

        var request = URLRequest(url: URL(string: getFormWebhookURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error submitting form: \(error.localizedDescription)")
                return
            }

            if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
                DispatchQueue.main.async {
                    print("Form successfully submitted")
                    showSuccessAlert = true
                }
            } else {
                DispatchQueue.main.async {
                    print("Failed to submit form")
                }
            }
        }.resume()
    }
}

// MARK: - MultiSelectPicker (accessible toggle rows)
struct MultiSelectPicker: View {
    let skills: [String]
    @Binding var selectedSkills: [String]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(skills, id: \.self) { skill in
                let isOn = selectedSkills.contains(skill)

                Button {
                    if isOn {
                        selectedSkills.removeAll { $0 == skill }
                    } else {
                        selectedSkills.append(skill)
                    }
                } label: {
                    HStack {
                        Text(skill)
                            .font(.body)                          // Dynamic Type
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                            .imageScale(.large)
                            .accessibilityHidden(true)            // icon is decorative; label conveys state
                    }
                    .contentShape(Rectangle())
                    .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(skill)
                .accessibilityValue(isOn ? "Selected" : "Not selected")
                .accessibilityHint("Double‑tap to toggle")
                .accessibilityIdentifier("skill_\(skill)")

                if skill != skills.last {
                    Divider()
                        .accessibilityHidden(true)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Skills list")
        .accessibilityHint("Select one or more skills")
    }
}

struct RegisterToCommunityView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterToCommunityView()
            .previewDisplayName("Default")

        RegisterToCommunityView()
            .environment(\.dynamicTypeSize, .accessibility3)
            .previewDisplayName("Large Text")
    }
}
