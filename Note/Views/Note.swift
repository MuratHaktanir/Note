//
//  ContentView.swift
//  Note
//
//  Created by Murat Haktanır on 13.11.2021.
//

import Foundation
import SwiftUI
import UserNotifications

struct Note: View {
    // MARK: - Properties
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme
    @Binding var notes: [Notes]
    let saveAction: () -> Void
    @State private var isPresented = false
    @State private var detailView = false
    @State private var newTitle = Notes.Data()
    
    @State private var toShowAlert : Bool = false
    @State private var notificationContent : UNNotificationContent?
    @State private var isLoading = true
    // MARK: - Body
    var body: some View {
        let notiName = "muradi"
        let pub = NotificationCenter.default.publisher(
            for: Notification.Name(notiName))
        
        NavigationView {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                
                if isLoading {
                    LaunchView(isLoading: $isLoading)
                }else {
                    
                    if notes.isEmpty {
                        EmptyNoteView(isPresented: $isPresented, newTitle: $newTitle, notes: $notes)
                    }else {
                        NoteListView(notes: $notes, isPresented: $isPresented, newTitle: $newTitle)
                        // MARK: - NewNote Button
                        Button(action: {
                            self.isPresented.toggle()
                        }, label: {
                            Image(systemName: "plus.circle")
                                .font(.title)
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
                                                        .foregroundColor(newTitle.title.isEmpty ? .secondary : .primary)
                                                        .disabled(newTitle.title.isEmpty)
                                                })
                                                
                                            }
                                            
                                        }
                                }
                            }
                    }
                }
            }
        }
        .onReceive(pub) { data in
            if let content = (data.object as? UNNotificationContent){
                self.notificationContent = content
                
            }
        }
        
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
        .onAppear{
            
            NotificationHandler.shared.requestPermission( onDeny: {
                
                self.toShowAlert.toggle()
                
            })
            
        }
        
        .alert(isPresented: $toShowAlert) {
            Alert(
               title: Text("Notification has been disabled for this app"),
               message: Text("Please go to settings to enable it now"),
               primaryButton: .default(Text("Go To Settings")) {
                   
                   self.goToSettings()
               },
               secondaryButton: .cancel()
            )
        }

        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension Note {
    
    
    private func goToSettings(){
        
        DispatchQueue.main.async {
         
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
          
        }
       
    }
    
    
    
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        Note(notes: .constant(Notes.data), saveAction: {})
    }
}
