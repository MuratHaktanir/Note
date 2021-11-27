//
//  ContentView.swift
//  Note
//
//  Created by Murat Haktanır on 13.11.2021.
//

import Foundation
import SwiftUI
import UserNotifications

@available(iOS 15.0, *)
struct Note: View {
    // MARK: - Properties
    @Environment(\.scenePhase)           private var scenePhase
    @Environment(\.colorScheme)          private var colorScheme
    @Binding var notes: [Notes]
    let saveAction: () -> Void
    @State                               private var isPresented = false
    @State                               private var detailView = false
    @State                               private var newTitle = Notes.Data()
    @State                               private var toShowAlert : Bool = false
    @State                               private var notificationContent : UNNotificationContent?
    @State                               private var isLoading = true
    @StateObject                                 var delegate = NotificationHandler()
    
    
    // MARK: - Body
    var body: some View {
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
                        Spacer()
                        AddButton(isPresented: $isPresented, notes: $notes)
                    }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
        .onAppear{
            UIApplication.shared.applicationIconBadgeNumber = 0
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

@available(iOS 15.0, *)
extension Note {
    private func goToSettings(){
        DispatchQueue.main.async {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
    }
}


// MARK: - Preview
@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        Note(notes: .constant(Notes.data), saveAction: {})
    }
}
