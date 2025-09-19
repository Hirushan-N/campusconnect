import SwiftUI
import MapKit

struct FindEventsView: View {
    @State private var searchText = "" // For search text
    
    private let items = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    private let width = (UIScreen.main.bounds.width) - 2
    
    private var filteredEvents: [Event] {
        if searchText.isEmpty {
            return sampleEvents
        } else {
            return sampleEvents.filter { event in
                event.title.lowercased().contains(searchText.lowercased()) ||
                event.tags.contains(where: { $0.lowercased().contains(searchText.lowercased()) })
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                CustomTextField(
                    text: $searchText,
                    placeholder: "Search By Name or Tag",
                    backgroundColor: Color(.systemGray6),
                    textColor: .black,
                    borderColor: .gray
                )
                .padding(.top, 20)
                
                VStack(spacing: 20) {
                    ForEach(filteredEvents) { event in
                        NavigationLink(destination: ViewEventView(
                            title: event.title,
                            description: event.description,
                            time: event.time,
                            venue: event.venue,
                            photoURL: event.photoURL,
                            latitude: event.latitude,
                            longitude: event.longitude,
                            onJoinAction: {
                                print("Join Event Button Pressed")
                            }
                        )) {
                            HStack(spacing: 16) {
                                // AsyncImage to load event image
                                AsyncImage(url: URL(string: event.photoURL)) { image in
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: width / 2, height: 160)
                                        .clipped()
                                        .cornerRadius(10)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: width / 2, height: 160)
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(event.title)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .bold()
                                    
                                    Text(event.description)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                        .lineLimit(2)
                                    
                                    Text("Time: \(event.time)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Text("Venue: \(event.venue)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Events")
        }
    }
}

#Preview {
    FindEventsView()
}
