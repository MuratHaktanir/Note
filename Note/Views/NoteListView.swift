//
//  NoteListView.swift
//  Note
//
//  Created by Murat Haktanır on 15.11.2021.
//

import UserNotifications
import SwiftUI

struct NoteListView: View {
    // MARK: - Properties
    @Environment(\.colorScheme)         var colorScheme
    @Binding                            var notes               : [Notes]
    @Binding                            var isPresented         : Bool
    @Binding                            var newTitle            : Notes.Data
    
    @State                      private var notificationContent : UNNotificationContent?
    
    @AppStorage("sort")                 var sort                = 0
    @AppStorage("showDoneList") private var showDoneList        = false
    @State                      private var sortByTitle         = false
    @State                      private var sortByManual        = true
    @State                      private var everyNote           = false
    @State                              var editMode: EditMode  = .inactive
    @State                              var searchtxt           = ""
    @State                      private var updatedNotes: [Notes] = []
    var sortTitle           : [Notes] {
        get { notes.sorted(by: {$0.title < $1.title})}
        set { notes = newValue}
    }
    
//    var deneme: [Notes] {
//        get { notes.filter{ $0.title = $1.title}}
//        set { notes = newValue}
//    }

    // MARK: - Body
    var body: some View {
        
        let notiName = "muradi"
        let pub = NotificationCenter.default.publisher(
            for: Notification.Name(notiName))
        
        //        UITableView.appearance().backgroundColor = .clear // tableview background
        //        UITableViewCell.appearance().backgroundColor = .clear // cell background
        
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            List {
                if sort == 0 {
                    Section(header: Text("Sort by Manual")) {
                        ForEach(searchtxt == "" ? notes : updatedNotes) { note in
                            if note.isComplete == false {
                                NavigationLink(destination: DetailNote(note: binding(for: note))) {
                                    NoteRow(note: note)
//                                        .searchable(text: $searchtxt)
                                }
                            }
                        }
                        .onDelete { (index) in
                            guard let firstIndex = index.first else {return}
                            self.removeItem(for: notes[firstIndex].id)
                        }
                        .onMove(perform: moveRows)
                    }
                    if showDoneList {
                        withAnimation {
                            Section(header: Text("Completed Items")) {
                                ForEach(searchtxt == "" ? notes : updatedNotes) { note in
                                    if note.isComplete == true {
                                        NavigationLink(destination: DetailNote(note: binding(for: note))) {
                                            NoteRow(note: note)
//                                                .searchable(text: $searchtxt)
                                        }
                                    }
                                }
                                .onDelete { (index) in
                                    guard let firstIndex = index.first else {return}
                                    self.removeItem(for: notes[firstIndex].id)
                                }
                                .onMove(perform: moveRows)
                            }
                        }
                    }
                }
                if sort == 1 {
                    Section(header: Text("Sort by Title")) {
                        ForEach(searchtxt == "" ? sortTitle : updatedNotes) { note in
                            if note.isComplete == false {
                                NavigationLink(destination: DetailNote(note: binding(for: note))) {
                                    NoteRow(note: note)
//                                        .searchable(text: $searchtxt)
                                }
                            }
                        }
                        .onDelete { (index) in
                            guard let firstIndex = index.first else {return}
                            self.removeItem(for: notes[firstIndex].id)
                        }
                    }
                    if showDoneList {
                        withAnimation {
                            Section(header: Text("Completed Items")) {
                                ForEach(searchtxt == "" ? sortTitle : updatedNotes) { note in
                                    if note.isComplete == true {
                                        NavigationLink(destination: DetailNote(note: binding(for: note))) {
                                            NoteRow(note: note)
//                                                .searchable(text: $searchtxt)
                                        }
                                    }
                                }
                                .onDelete { (index) in
                                    guard let firstIndex = index.first else {return}
                                    self.removeItem(for: notes[firstIndex].id)
                                }
                            }
                        }
                    }
                }
                
                if sort == 2 {
                    Section(header: Text("All notes")) {
                        ForEach(searchtxt == "" ? sortTitle : updatedNotes) { note in
                            if note.isComplete == false {
                                NavigationLink(destination: DetailNote(note: binding(for: note))) {
                                    NoteRow(note: note)
//                                        .searchable(text: $searchtxt)
                                }
                            }
                        }
                        .onDelete { (index) in
                            guard let firstIndex = index.first else {return}
                            self.removeItem(for: notes[firstIndex].id)
                        }
                    }
                    if showDoneList {
                        withAnimation {
                            Section(header: Text("Completed Items")) {
                                ForEach(searchtxt == "" ? sortTitle : updatedNotes) { note in
                                    if note.isComplete == true {
                                        NavigationLink(destination: DetailNote(note: binding(for: note))) {
                                            NoteRow(note: note)
//                                                .searchable(text: $searchtxt)
                                        }
                                    }
                                }
                                .onDelete { (index) in
                                    guard let firstIndex = index.first else {return}
                                    self.removeItem(for: notes[firstIndex].id)
                                }
                            }
                        }
                    }
                }
            }
            .animation(.default, value: sort)
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Notes")
            .listRowBackground(Color.primary)
            //            .background(Color(colorScheme == .light ? .systemFill : .opaqueSeparator).ignoresSafeArea())
            
            // Mark: - Searchbar
            .searchable(text: $searchtxt, prompt: "Find your note.")
            .onChange(of: searchtxt, perform: { searchValue in
                updatedNotes = notes.filter {$0.title.contains(searchtxt)}
            })
            // MARK: - Toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        EditButton()
                        Menu {
                            
                            Picker("", selection: $sort) {
                                Button(action: {
                                    sortByManual.toggle()
                                }, label: {Text("Manual")}).tag(0)
                                Button(action: {
                                    sortByTitle.toggle()
                                }, label: {Text("Title")}).tag(1)
                                Button(action: {
                                    everyNote.toggle()
                                }, label: {
                                    Text("All")
                                }).tag(2)
                            }
                        }label: {
                            Label("Sort by: ", systemImage: "arrow.up.arrow.down.circle")
                        }
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                showDoneList.toggle()
                            }
                        }, label: {
                            Text(showDoneList ? "Hide Completed" : "Show Completed")
                            Image(systemName: showDoneList ? "eye.slash" : "eye")
                        })
//                            .disabled(sort == 2)
                    } label: {
                        Label("", systemImage: "ellipsis.circle")
                    }
                }
                
//                ToolbarItem(placement: .navigationBarLeading) {
//                    EditButton()
//                }
                
            }
            .environment(\.editMode, self.$editMode)
            // MARK: - Notification
            .onReceive(pub) { data in
                if let content = (data.object as? UNNotificationContent){
                    self.notificationContent = content
                    
                }
            }
        }
    }
    
    // MARK: - Functions
    private func binding(for note: Notes) -> Binding<Notes> {
        guard let noteIndex = notes.firstIndex(where: {$0.id == note.id}) else {
            fatalError("Can't find note in array")
        }
        return $notes[noteIndex]
    }
    
    private func deleteItems(at offsets: IndexSet) {
        withAnimation {
            notes.remove(atOffsets: offsets)
        }
        
    }
    
    private func removeItem(for id: UUID) {
        self.notes.removeAll(where: {$0.id == id})
    }
    
    private func moveRows(source: IndexSet, destination: Int) {
        notes.move(fromOffsets: source, toOffset: destination)
    }
    


}
