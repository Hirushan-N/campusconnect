//  CommunityData.swift
//  campusconnect
//
//

import Foundation

struct CommunityMember: Identifiable {
    var id = UUID()
    var name: String
    var imageURL: String
}

struct Community: Identifiable {
    let id: UUID
    let name: String
    let photoURL: String
    let tags: [String]
    let description: String
    var leader: CommunityMember
    var members: [CommunityMember]
    var skills: [String]
    var totalMembers: Int {
        return members.count + 1
    }
    
    init(name: String, photoURL: String, tags: [String], description: String, leader: CommunityMember, members: [CommunityMember], skills: [String]) {
        self.id = UUID()
        self.name = name
        self.photoURL = photoURL
        self.tags = tags
        self.description = description
        self.leader = leader
        self.members = members
        self.skills = skills
    }
}

let defaultImageURL = "https://i.ibb.co/tw4ktVk1/images.png"

let popularCommunities: [Community] = [
    Community(
        name: "Foss Community",
        photoURL: defaultImageURL,
        tags: ["Technology", "Coding", "Programming"],
        description: "A club for technology enthusiasts, focusing on coding and programming.",
        leader: CommunityMember(name: "Supun", imageURL: "https://i.ibb.co/1Hz4W78/5873314.webp"),
        members: [
            CommunityMember(name: "Ashan", imageURL: "https://i.ibb.co/23gg7qzh/images.jpg"),
            CommunityMember(name: "Gihan", imageURL: "https://i.ibb.co/Gvp49GDk/images.jpg"),
            CommunityMember(name: "Sapumal", imageURL: "https://i.ibb.co/0RQ56ScY/sports-boy-3d-icon-download-in-png-blend-fbx-gltf-file-formats-male-player-child-cute-avatar-pack-pe.png")
        ],
        skills: ["Swift", "Java", "C++", "Python"]
    ),
    Community(
        name: "MS Club of Campus",
        photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Microsoft_logo.svg/2048px-Microsoft_logo.svg.png",
        tags: ["Photography", "Technology", "Coding"],
        description: "Explore the world of photography, from camera techniques to photo editing.",
        leader: CommunityMember(name: "Jane Smith", imageURL: defaultImageURL),
        members: [
            CommunityMember(name: "Eve", imageURL: defaultImageURL),
            CommunityMember(name: "Mallory", imageURL: defaultImageURL),
            CommunityMember(name: "Trudy", imageURL: defaultImageURL)
        ],
        skills: ["Photography", "Editing", "Camera Operation"]
    ),
    Community(
        name: "Leo Club of Campus",
        photoURL: "https://cdn.vectorstock.com/i/1000v/56/98/lion-head-logo-template-vector-22025698.jpg",
        tags: ["Acting", "Theater", "Performance"],
        description: "A club where aspiring actors can practice and perform theatrical plays.",
        leader: CommunityMember(name: "David Williams", imageURL: defaultImageURL),
        members: [
            CommunityMember(name: "Sophie", imageURL: defaultImageURL),
            CommunityMember(name: "Ryan", imageURL: defaultImageURL),
            CommunityMember(name: "Olivia", imageURL: defaultImageURL)
        ],
        skills: ["Acting", "Directing", "Playwriting", "Stage Design"]
    ),
]
