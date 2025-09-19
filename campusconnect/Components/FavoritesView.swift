//
//  FavoritesView.swift
//  campusconnect
//
//  Created by Gihan Sudeepa on 2025-03-08.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack {
                // Segmented Control
                Picker("Favorites", selection: $selectedTab) {
                    Text("Communities").tag(0)
                    Text("Events").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Content based on selected tab
                if selectedTab == 0 {
                    CommunitiesFavoritesList()
                } else {
                    EventsFavoritesList()
                }
            }
            .navigationTitle("My Favorites")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct CommunitiesFavoritesList: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    private let allCommunities = popularCommunities
    
    private var favoriteCommunities: [Community] {
        favoritesManager.getFavoriteCommunities(from: allCommunities)
    }
    
    var body: some View {
        if favoriteCommunities.isEmpty {
            VStack(spacing: 20) {
                Image(systemName: "heart.slash")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("No Favorite Communities")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Text("Communities you favorite will appear here")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                ForEach(favoriteCommunities, id: \.id) { community in
                    CommunityFavoriteRow(community: community)
                }
                .onDelete(perform: deleteCommunities)
            }
        }
    }
    
    private func deleteCommunities(offsets: IndexSet) {
        for index in offsets {
            let community = favoriteCommunities[index]
            favoritesManager.removeCommunityFromFavorites(community.id.uuidString)
        }
    }
}

struct EventsFavoritesList: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    private let allEvents = sampleEvents
    
    private var favoriteEvents: [Event] {
        favoritesManager.getFavoriteEvents(from: allEvents)
    }
    
    var body: some View {
        if favoriteEvents.isEmpty {
            VStack(spacing: 20) {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("No Favorite Events")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Text("Events you favorite will appear here")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                ForEach(favoriteEvents, id: \.id) { event in
                    EventFavoriteRow(event: event)
                }
                .onDelete(perform: deleteEvents)
            }
        }
    }
    
    private func deleteEvents(offsets: IndexSet) {
        for index in offsets {
            let event = favoriteEvents[index]
            favoritesManager.removeEventFromFavorites(event.id.uuidString)
        }
    }
}

struct CommunityFavoriteRow: View {
    let community: Community
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: community.photoURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(community.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(community.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "person.2.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text("\(community.totalMembers) members")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct EventFavoriteRow: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.title)
                .font(.headline)
                .lineLimit(1)
            
            Text(event.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Image(systemName: "calendar")
                    .font(.caption)
                    .foregroundColor(.blue)
                Text(event.time)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Image(systemName: "location")
                    .font(.caption)
                    .foregroundColor(.green)
                Text(event.venue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// Preview
struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
