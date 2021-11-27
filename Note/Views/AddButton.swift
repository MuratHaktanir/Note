//
//  AddButton.swift
//  Note
//
//  Created by Murat Haktanır on 22.11.2021.
//

import SwiftUI

struct AddButton: View {
    // MARK: - Properties
    @Binding var isPresented: Bool
    @State                               private var newTitle = Notes.Data()
    @Binding var notes: [Notes]
    @State                               private var notificationContent : UNNotificationContent?
    // MARK: - Body
    var body: some View {
        let notiName = "muradi"
        let pub = NotificationCenter.default.publisher(
            for: Notification.Name(notiName))

        Button(action: {
            self.isPresented.toggle()
        }, label: {
            Image(systemName: "plus.circle")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundColor(.primary)
                .padding()
            
        })
        
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    NewNote(newTitle: $newTitle)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    isPresented = false
                                    self.newTitle.title = ""
                                    self.newTitle.detail = ""
                                }) {
                                    Image(systemName: "xmark.circle")
                                        .font(.title3)
                                        .foregroundColor(.primary)
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    let newTitle = Notes(title: newTitle.title, detail: newTitle.detail, day: newTitle.day, time: newTitle.time, notifyDay: newTitle.notifyDay, notifyTime: newTitle.notifyTime, isComplete: newTitle.isComplete)
                                    
                                    if newTitle.notifyDay {
                                        let calendar = Calendar.current
                                        let components = calendar.dateComponents([.day,.hour, .minute], from: newTitle.time )
                                        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                                        NotificationHandler.shared.addNotification(id: notiName, title: newTitle.title, subtitle: newTitle.detail, trigger: trigger)
                                    }
                                    
                                    notes.append(newTitle)
                                    isPresented = false
                                    self.newTitle.title = ""
                                    self.newTitle.detail = ""
                                    
                                }, label: {
                                    Image(systemName: "plus.circle")
                                        .font(.title3)
                                        .foregroundColor(newTitle.title.isEmpty ? .secondary : .primary)
                                        .disabled(newTitle.title.isEmpty)
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

