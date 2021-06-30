//
//  LearningSwiftApp.swift
//  LearningSwift
//
//  Created by DHV on 14/06/2021.
//

import SwiftUI
import Firebase

@main
struct LearningSwiftApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(ContentModel())
        }
    }
}
