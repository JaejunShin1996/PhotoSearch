//
//  PhotoCollection.swift
//  PhotoSearch
//
//  Created by Jaejun Shin on 12/12/2022.
//

import Foundation

extension PhotoCollection {
    var unwrappedID: UUID {
        id ?? UUID()
    }

    var unwrappedTitle: String {
        title ?? "Example"
    }

    var unwrappedDate: Date {
        date ?? .now
    }

    var savedPhotos: [SavedPhoto] {
        photos?.allObjects as? [SavedPhoto] ?? []
    }

    static let example = PhotoCollection()
}
