//
//  NoteRow.swift
//  Note
//
//  Created by Murat Haktanır on 15.11.2021.
//

import SwiftUI

struct NoteRow: View {
    // MARK: - Properties
    var note: Notes
    
    // MARK: - Body
    var body: some View {
        ZStack {
            if note.notifyDay {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(note.title)
                            Spacer()
                            Text(note.isComplete ? "Done" : "Not yet")
                                .font(.footnote)
                                .foregroundColor(note.isComplete ? .green : .red)
                        }
                        HStack {
                            Text(note.detail.isEmpty ? "" : note.detail)
                                .font(.footnote)
                                .lineLimit(2)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(note.day, formatter: dateFormatter)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Text(note.notifyTime ? "\(note.time, style: .time)" : "")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .animation(.default, value: note.notifyDay)
                }
            }else {
                if note.detail.isEmpty {
                    VStack(alignment:.leading, spacing: 5) {
                        HStack {
                            Text(note.title)
                            Spacer()
                            Text(note.isComplete ? "Done" : "Not yet")
                                .font(.footnote)
                                .foregroundColor(note.isComplete ? .green : .red)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }else {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(note.title)
                            Spacer()
                            Text(note.isComplete ? "Done" : "Not yet")
                                .font(.footnote)
                                .foregroundColor(note.isComplete ? .green : .red)
                        }
                        HStack {
                            Text(note.detail)
                                .font(.footnote)
                                .lineLimit(2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "MMM d"
        
        df.dateStyle = .medium
        df.doesRelativeDateFormatting = true
        
        return df
    }    
}
// MARK: - Preview
struct NoteRow_Previews: PreviewProvider {
    static let note = Notes(title: "Note 1",
                            detail: "Note 1 detail about something",
                            day: Date(),
                            time: Date(),
                            notifyDay: true,
                            notifyTime: true,
                            isComplete: false)
    static var previews: some View {
        NoteRow(note: note)
    }
}
