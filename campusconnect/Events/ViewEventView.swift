import SwiftUI
import MapKit

struct ViewEventView: View {
    @State var title: String
    var description: String
    var time: String
    var venue: String
    var photoURL: String
    var latitude: Double
    var longitude: Double
    var onJoinAction: () -> Void

    @StateObject private var favoritesManager = FavoritesManager.shared
    private let width = UIScreen.main.bounds.width - 32

    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Header Image for the Event
                        AsyncImage(url: URL(string: photoURL)) { image in
                            image.resizable()
                                .scaledToFill()
                                .clipped()
                                .cornerRadius(10)
                                .padding()
                        } placeholder: {
                            ProgressView()
                                .frame(width: width, height: 250)
                        }
                        .padding(.top)

                        // Event Title
                        Text(title)
                            .font(.system(size: 24))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        // Event Time and Venue
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Time: \(time)")
                                .font(.body)

                            Text("Venue: \(venue)")
                                .font(.body)
                        }
                        .padding(.horizontal)

                        // Event Description
                        Text(description)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        // In‑app Map Preview (with pin)
                        Map(position: $cameraPosition) {
                            Marker(title, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                        }
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        .accessibilityLabel("Map preview for \(title) at \(venue)")
                    }
                    .padding(.bottom, 16)
                }

                CustomButton(
                    title: "Go to Event Location",
                    backgroundColor: Color.blue,
                    textColor: Color.white
                ) {
                    openMapWithCoordinates(latitude: latitude, longitude: longitude)
                }
                .padding()
                .simultaneousGesture(TapGesture().onEnded {
                    onJoinAction()
                })
                .background(
                    Color.white
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.1), .clear]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 6),
                            alignment: .top
                        )
                )
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if favoritesManager.isEventFavorited(title) {
                            favoritesManager.removeEventFromFavorites(title)
                        } else {
                            favoritesManager.addEventToFavoritesByName(title)
                        }
                    }) {
                        Image(systemName: favoritesManager.isEventFavorited(title) ? "heart.fill" : "heart")
                            .foregroundColor(favoritesManager.isEventFavorited(title) ? .red : .primary)
                    }
                }
            }
        }
        .onAppear {
            let coord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(
                center: coord,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            cameraPosition = .region(region)
        }
    }

    // func to open the default map app with coordinates
    func openMapWithCoordinates(latitude: Double, longitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let regionSpan = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = title
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ])
    }
}

struct ViewEventView_Previews: PreviewProvider {
    static var previews: some View {
        return ViewEventView(
            title: "Campus Tech Talk",
            description: "Join us for an informative tech talk about the future of AI and machine learning...",
            time: "April 10, 2025, 2:00 PM",
            venue: "Campus Auditorium",
            photoURL: "https://example.com/event-image.jpg",
            latitude: 6.9271,
            longitude: 79.8612,
            onJoinAction: {
                print("Join Event Button Pressed")
            }
        )
    }
}
