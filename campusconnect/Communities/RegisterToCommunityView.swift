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
    
    private let skills = ["Swift", "Java", "Python", "C++", "UI/UX Design"]
    private let getFormWebhookURL = "https://getform.io/f/akkpddja"

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    Group {
                        TextField("Enter Name", text: $name)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        
                        TextField("Enter Email", text: $email)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        
                        TextField("Enter Year", text: $year)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        
                        TextField("Enter Semester", text: $semester)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        
                        TextEditor(text: $aboutYourself)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                            .frame(height: 150)
                            .overlay(
                                Text("Tell Us About Yourself")
                                    .foregroundColor(.gray)
                                    .padding(.top, 10)
                                    .padding(.leading, 14),
                                alignment: .topLeading
                            )
                    }
                    
                    Text("Select Skills")
                        .padding(.top)
                    
                    MultiSelectPicker(skills: skills, selectedSkills: $selectedSkills)
                        .padding(.vertical)
                    
                    Button(action: {
                        submitForm()
                    }) {
                        Text("Submit")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
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
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error submitting form: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
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


struct MultiSelectPicker: View {
    let skills: [String]
    @Binding var selectedSkills: [String]
    
    var body: some View {
        VStack {
            ForEach(skills, id: \.self) { skill in
                HStack {
                    Text(skill)
                    Spacer()
                    Image(systemName: selectedSkills.contains(skill) ? "checkmark.circle.fill" : "circle")
                        .onTapGesture {
                            if selectedSkills.contains(skill) {
                                selectedSkills.removeAll { $0 == skill }
                            } else {
                                selectedSkills.append(skill)
                            }
                        }
                }
                .padding(.vertical, 5)
                .contentShape(Rectangle()) // Make the whole row tappable
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
    }
}

struct RegisterToCommunityView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterToCommunityView()
    }
}
