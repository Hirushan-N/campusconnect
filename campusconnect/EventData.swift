//  EventData.swift
//  campusconnect
//
//

import Foundation

struct Event: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let time: String
    let venue: String
    let tags: [String] // For search purposes
    let photoURL: String // Add photoURL for the image
    let latitude: Double  // Added latitude for the event location
    let longitude: Double // Added longitude for the event location
    
    init(title: String, description: String, time: String, venue: String, tags: [String], photoURL: String, latitude: Double, longitude: Double) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.time = time
        self.venue = venue
        self.tags = tags
        self.photoURL = photoURL
        self.latitude = latitude
        self.longitude = longitude
    }
}

let sampleEvents: [Event] = [
    Event(
        title: "Campus's Got Talent by FESC",
        description: "A talent competition by the Faculty of Engineering Student Community highlighting student skills in music, dance, drama and more.",
        time: "2025/07/05",
        venue: "Malabe Campus Grounds",
        tags: ["Talent Show", "FESC", "Entertainment"],
        photoURL: "https://i.ibb.co/Rk1f3XmJ/8212616.png",
        latitude: 6.9147,
        longitude: 79.9728
    ),
    Event(
        title: "Campus Walk",
        description: "An annual walk to promote unity and well-being among students and staff, featuring music, charity fundraising, and fun activities.",
        time: "2025/08/15",
        venue: "From Campus to Parliament Grounds",
        tags: ["Walk", "Community", "Charity"],
        photoURL: "https://i.ibb.co/kVw6G6zw/images.jpg",
        latitude: 6.9147,
        longitude: 79.9728
    ),
    Event(
        title: "Blood Donation",
        description: "Organized by the Faculty of Computing Student Community, this drive encourages students to donate blood and support healthcare.",
        time: "2025/09/10",
        venue: "New Academic Building Lobby",
        tags: ["Health", "Charity", "FCSC"],
        photoURL: "https://i.ibb.co/gMx8Dh3q/FCSC-organized-Annual-Blood-Donation-Campaign-Drops-of-hope24.jpg",
        latitude: 6.9147,
        longitude: 79.9728
    ),
]
