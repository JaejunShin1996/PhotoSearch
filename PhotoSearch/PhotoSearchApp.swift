//
//  PhotoSearchApp.swift
//  PhotoSearch
//
//  Created by Jaejun Shin on 7/12/2022.
//

import SwiftUI

@main
struct PhotoSearchApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
