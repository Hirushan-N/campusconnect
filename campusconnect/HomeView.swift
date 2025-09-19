//
//  ContentView.swift
//  campusconnect
//
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header Section with Background Image
                ZStack(alignment: .leading) {
                    Image("headerBackground")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
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
                                    .frame(width: 120, height: 120)
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
        .navigationTitle("")  // Empty title to avoid duplication
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.primary)
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
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.white)
            Text(title)
                .foregroundColor(.white)
                .bold()
        }
        .frame(width: UIScreen.main.bounds.width / 2 - 20, height: 200)
        .background(color)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
