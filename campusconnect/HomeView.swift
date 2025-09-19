import SwiftUI

struct HomeView: View {
    // Scale certain sizes with Dynamic Type to preserve proportions
    @ScaledMetric(relativeTo: .title) private var headerHeight: CGFloat = 250
    @ScaledMetric(relativeTo: .body)  private var thumbSize: CGFloat = 120

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header Section with Background Image
                ZStack(alignment: .leading) {
                    Image("headerBackground")
                        .resizable()
                        .scaledToFill()
                        .frame(height: headerHeight)
                        .clipped()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome to Campus Connect")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)

                        Text("Your secure gateway to campus communities")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .shadow(radius: 1)
                    }
                    .padding()
                }

                // Popular Communities Section
                Text("Popular Communities")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(popularCommunities) { community in
                            let destinationView = ViewCommunityView(
                                title: community.name,
                                photoURL: community.photoURL,
                                leader: community.leader,
                                members: community.members,
                                description: community.description,
                                onJoinAction: {
                                    print("Joined \(community.name)")
                                }
                            )

                            NavigationLink(destination: destinationView) {
                                VStack {
                                    AsyncImage(url: URL(string: community.photoURL)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: thumbSize, height: thumbSize)
                                    .cornerRadius(10)

                                    Text(community.name)
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Explore Section
                Text("Explore")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)

                HStack(spacing: 16) {
                    NavigationLink(destination: FindCommunitiesView()) {
                        CustomExploreButton(title: "Find Communities", icon: "person.3.fill", color: .blue)
                    }
                    NavigationLink(destination: FindEventsView()) {
                        CustomExploreButton(title: "Find Events", icon: "calendar", color: .orange)
                    }
                }
                .padding(.horizontal)

                // Favorites Section
                Text("My Favorites")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)

                NavigationLink(destination: FavoritesView()) {
                    CustomExploreButton(title: "View Favorites", icon: "heart.fill", color: .red)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.primary)
                        .imageScale(.large)
                }
            }
        }
    }
}

// Custom Button for Explore Section
struct CustomExploreButton: View {
    var title: String
    var icon: String
    var color: Color

    // Scale card height/corner to match Dynamic Type
    @ScaledMetric(relativeTo: .title2) private var cardHeight: CGFloat = 200
    @ScaledMetric(relativeTo: .body)   private var cornerRadius: CGFloat = 15
    @ScaledMetric(relativeTo: .title)  private var vPad: CGFloat = 12

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.white)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .frame(width: UIScreen.main.bounds.width / 2 - 20, height: cardHeight)
        .padding(.vertical, vPad)
        .background(color)
        .cornerRadius(cornerRadius)
        .shadow(radius: 5)
        .contentShape(Rectangle())
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .previewDisplayName("Default")

            HomeView()
                .environment(\.dynamicTypeSize, .accessibility3)
                .previewDisplayName("Large Text")
        }
    }
}
