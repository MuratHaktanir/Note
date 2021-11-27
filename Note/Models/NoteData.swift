//
//  NoteData.swift
//  Note
//
//  Created by Murat Haktanır on 15.11.2021.
//

import Foundation
import SwiftUI

final class NoteData: ObservableObject {
    
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

