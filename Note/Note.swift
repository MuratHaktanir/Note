//
//  ContentView.swift
//  Note
//
//  Created by Murat Haktanır on 13.11.2021.
//

import SwiftUI

struct Note: View {
    // MARK: - Properties
    @Environment(\.scenePhase) private var scenePhase
    @Binding var notes: [Notes]
    
    let saveAction: () -> Void
    
    @State private var isPresented = false
    @State private var newTitle = Notes.Data()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                if notes.isEmpty {
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
                                            let newTitle = Notes(title: newTitle.title)
                                            notes.append(newTitle)
                                            isPresented = false
                                        }, label: {
                                            Image(systemName: "plus.circle")
                                                .foregroundColor(.primary)
                                        })
                                    }
                                }
                        }
                    }
                }else {
                    List {
                        ForEach(notes) { note in
                            NavigationLink(destination: DetailNote(note: binding(for: note))) {
                                NoteRow(note: note)
                            }
                        }
                        .onDelete { indices in
                            withAnimation {
                                notes.remove(atOffsets: indices)
                            }
                        }
                    }
                    .listStyle(InsetListStyle())
                    .navigationTitle("Notes")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isPresented = true
                            }, label: {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.primary)
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
                                                        let newTitle = Notes(title: newTitle.title)
                                                        notes.append(newTitle)
                                                        isPresented = false
                                                    }, label: {
                                                        Image(systemName: "plus.circle")
                                                            .foregroundColor(.primary)
                                                    })
                                                }
                                            }
                                    }
                                }
                        }
                    }
                }
            }
        }
        .zIndex(0.9)
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
    private func binding(for note: Notes) -> Binding<Notes> {
        guard let noteIndex = notes.firstIndex(where: {$0.id == note.id}) else {
            fatalError("Can't find note in array")
        }
        return $notes[noteIndex]
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        Note(notes: .constant(Notes.data), saveAction: {})
    }
}


// MARK: - Notes
struct Notes: Codable, Identifiable {
    
    let id: UUID
    var title: String
    
    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
    
}

extension Notes {
    static var data: [Notes] {
        [
            Notes(title: "Note 1"),
            Notes(title: "Note 2")
        ]
    }
}

extension Notes {
    struct Data {
        var title: String = ""
    }
    
    var data: Data {
        return Data(title: title)
    }
    
    mutating func update(from data: Data) {
        title = data.title
    }
}

// MARK: - Notes Data Model

class NoteData: ObservableObject {
    
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("notes.data")
    }
    
    @Published var notesModel: [Notes] = []
    
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                #if DEBUG
                DispatchQueue.main.async {
                    self?.notesModel = Notes.data
                }
                #endif
                return
            }
            guard let notes = try? JSONDecoder().decode([Notes].self, from: data) else {
                fatalError("Can't decode saved notes data.")
            }
            DispatchQueue.main.async {
                self?.notesModel = notes
            }
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let notesModel = self?.notesModel else { fatalError("Self out of scope") }
            guard let data = try? JSONEncoder().encode(notesModel) else { fatalError("Error encoding data") }
            do {
                let outfile = Self.fileURL
                try data.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
}

// MARK: - Note Row View

struct NoteRow: View {
    let note: Notes
    var body: some View {
        
        HStack {
            Text(note.title)
            Spacer()
            Image(systemName: "info.circle")
                .foregroundColor(.primary)
        }
        
    }
}


// MARK: - New Note View

struct NewNote: View {
    @Binding var newTitle: Notes.Data
    var body: some View {
        Form {
            HStack {
                TextField("Add a note", text: $newTitle.title)
                Spacer()
            }
        }
    }
}


// MARK: - Detail Note View

struct DetailNote: View {
    @Binding var note: Notes
    var body: some View {
        Form {
            TextField("Note", text: $note.title)
        }
        .navigationTitle(note.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
