//
//  LearningSwiftApp.swift
//  LearningSwift
//
//  Created by DHV on 14/06/2021.
//

import SwiftUI

@main
struct LearningSwiftApp: App {
    var body: some Scene {
        WindowGroup {
            LearningSwiftView()
                .environmentObject(ContentModel())
        }
    }
}
