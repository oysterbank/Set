//
//  SetApp.swift
//  Set
//
//  Created by Kris Laratta on 9/25/21.
//

import SwiftUI

@main
struct SetApp: App {
    private let game = SetGameViewModel()

    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
