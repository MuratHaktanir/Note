//
//  oldlist.swift
//  Note
//
//  Created by Murat Haktanır on 19.11.2021.
//

import SwiftUI

struct oldlist: View {
    // MARK: - Properties
    @Environment(\.colorScheme)         var colorScheme
    @Binding                            var notes               : [Notes]
    @Binding                            var isPresented         : Bool
    @Binding                            var newTitle            : Notes.Data
    @State                      private var notificationContent : UNNotificationContent?
    
    @AppStorage("sort")                 var sort                = 0
    @State                      private var showDoneList        = false
    @State                      private var sortByTitle         = false
    @State                      private var sortByManual        = true
    @State                      private var everyNote           = false
    @State                              var editMode: EditMode  = .inactive
                                        var sortTitle           : [Notes] {
                                            get { notes.sorted(by: {$0.title < $1.title})}
                                            set { notes = newValue}
                                        }
    
    var body: some View {
        
        let notiName = "muradi"
        let pub = NotificationCenter.default.publisher(
            for: Notification.Name(notiName))
        
        
        ZStack{
            List {
                Section(header: Text(notes.isEmpty ? "" : "Not yet")) {
                                   ForEach(notes) { note in
                                       if note.isComplete == false {
                                           NavigationLink(destination: DetailNote(note: binding(for: note))) {
                                               NoteRow(note: note)
                                           }
                                       }
                                   }
                }
                if showDoneList {
                    withAnimation {
                        Section(header: Text("Done")) {
                            ForEach(notes) { note in
                                if note.isComplete == true {
                                    NavigationLink(destination: DetailNote(note: binding(for: note))) {
                                        NoteRow(note: note)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            self.showDoneList.toggle()
                        }
                    }, label: {
                        Image(systemName: self.showDoneList ? "checkmark.circle" : "circle")
                                                    .foregroundColor(showDoneList ? .green : .red)
                    })
                }
            }
        }
        
        .onReceive(pub) { data in
            if let content = (data.object as? UNNotificationContent){
                self.notificationContent = content
                
            }
        }
    }
    private func binding(for note: Notes) -> Binding<Notes> {
        guard let noteIndex = notes.firstIndex(where: {$0.id == note.id}) else {
            fatalError("Can't find note in array")
        }
        return $notes[noteIndex]
    }
}
