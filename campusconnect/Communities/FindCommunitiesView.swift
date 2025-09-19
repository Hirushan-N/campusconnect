//
//  FindCommunitiesView.swift
//  campusconnect
//
//

import SwiftUI

struct FindCommunitiesView: View {
    @State private var searchText = ""
    
    private let items = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    // Function to filter communities based on search text
    private func filterCommunities(searchText: String) -> [Community] {
        if searchText.isEmpty {
            return popularCommunities
        } else {
            return popularCommunities.filter { community in
                community.name.lowercased().contains(searchText.lowercased()) ||
                community.tags.contains(where: { $0.lowercased().contains(searchText.lowercased()) })
            }
        }
    }
    
    private let width = (UIScreen.main.bounds.width / 2) - 20
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    CustomTextField(
                        text: $searchText,
                        placeholder: "Search By Name or Tag",
                        backgroundColor: Color(.systemGray6),
                        textColor: .black,
                        borderColor: .gray
                    )
                    .padding(.top, 20)
                    
                    // Use filterCommunities method here
                    let filteredCommunities = filterCommunities(searchText: searchText)
                    
                    LazyVGrid(columns: items, spacing: 2) {
                        ForEach(filteredCommunities) { community in
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
                                    .frame(width: width, height: width)
                                    .cornerRadius(10)
                                    
                                    Text(community.name)
                                        .foregroundColor(.black)
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }

                    }
                    .padding(10)
                }
            }
            .navigationTitle("Find Communities")
        }
    }
}

#Preview {
    FindCommunitiesView()
}
