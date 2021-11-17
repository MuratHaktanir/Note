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
    // MARK: - Body
    var body: some View {
        
        let notiName = "muradi"
        let pub = NotificationCenter.default.publisher(
                           for: Notification.Name(notiName))
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
                            Button(action: {
                                isPresented = false
                            }) {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.primary)
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                let newTitle = Notes(title: newTitle.title, detail: newTitle.detail, day: newTitle.day, time: newTitle.time, notifyDay: newTitle.notifyDay, notifyTime: newTitle.notifyTime, isComplete: newTitle.isComplete)
                    
                                if newTitle.notifyDay {
                                    let calendar = Calendar.current
                                    let components = calendar.dateComponents([.hour, .minute], from: newTitle.time )
                                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                                    NotificationHandler.shared.addNotification(id: notiName, title: newTitle.title, subtitle: newTitle.detail, trigger: trigger)
                                }
                                
                                notes.append(newTitle)
                                self.newTitle.title = ""
                                self.newTitle.detail = ""
                                isPresented = false
                                
                            }, label: {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(newTitle.title.isEmpty ? .gray : .primary)
                            })
                                .disabled(newTitle.title.isEmpty)
                        }
                    }
            }
        }
        .onReceive(pub) { data in
            if let content = (data.object as? UNNotificationContent){
                self.notificationContent = content
                
            }
        }
    }
}
