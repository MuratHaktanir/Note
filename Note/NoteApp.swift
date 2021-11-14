//
//  NoteApp.swift
//  Note
//
//  Created by Murat Haktanır on 13.11.2021.
//

import SwiftUI

@main
struct NoteApp: App {
    @ObservedObject private var data = NoteData()
    var body: some Scene {
        WindowGroup {
            Note(notes: $data.notesModel) {
                data.save()
            }
                .onAppear {
                    data.load()
                }
        }
    }
}
