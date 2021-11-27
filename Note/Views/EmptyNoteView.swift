//
//  EmptyNoteView.swift
//  Note
//
//  Created by Murat Haktanır on 15.11.2021.
//

import UserNotifications
import SwiftUI

struct EmptyNoteView: View {
    // MARK: - Properties
    @Binding var isPresented: Bool
    @Binding var newTitle: Notes.Data
    @Binding var notes: [Notes]
    @State private var notificationContent : UNNotificationContent?
    @Environment(\.colorScheme) var colorScheme
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? .systemFill : .opaqueSeparator).ignoresSafeArea()
            VStack {
                Text("Please touch,\nif you want to add a note.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .navigationTitle("Notes")
            .onTapGesture {
                isPresented = true
            }
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    NewNote(newTitle: $newTitle)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                DismissButtonForNote(isPresented: $isPresented, newTitle: $newTitle)
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                AddButtonForNewNote(isPresented: $isPresented, newTitle: $newTitle, notes: $notes)
                            }
                        }
                }
            }
        }
    }
}
