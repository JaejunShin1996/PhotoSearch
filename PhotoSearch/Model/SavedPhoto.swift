//
//  SavedPhoto.swift
//  PhotoSearch
//
//  Created by Jaejun Shin on 12/12/2022.
//

import Foundation

extension SavedPhoto {
    var unwrappedDate: Date {
        creationDate ?? .now
    }

    var unwrappedPhotoData: Data {
        photoData ?? Data()
    }
}
