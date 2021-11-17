//
//  NewNote.swift
//  Note
//
//  Created by Murat Haktanır on 15.11.2021.
//

import SwiftUI

struct NewNote: View {
    // MARK: - Properties
    @Binding var newTitle: Notes.Data
    @State var dayTapped = false
    @State var timeTapped = false
    // MARK: - Body
    var body: some View {
        Form {
            Section(header: Text("Taking note")) {
                TextField("Add a note", text: $newTitle.title)
                TextEditor(text: $newTitle.detail)
                    .foregroundColor(.secondary)
                    .font(.callout)
            }
            
            Section(header: Text("Calendar & Time")) {
                
                Toggle(isOn: $newTitle.notifyDay) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.purple)
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fit)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Calendar")
                                .fontWeight(.semibold)
                            if newTitle.notifyDay {
                                Text(newTitle.day, formatter: dateFormatter)
                                    .environment(\.locale, Locale(identifier: "En"))
                                    .font(.footnote)
                            }
                        }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if newTitle.notifyDay {
                        self.dayTapped.toggle()
                    }
                }
                .onChange(of: newTitle.notifyDay, perform: {value in
                    if value {
                        self.dayTapped = true
                    }else {
                        self.newTitle.notifyTime = false
                        self.timeTapped = false
                    }
                })
                
                if newTitle.notifyDay && dayTapped {
                    DatePicker("Choose a day", selection: $newTitle.day, displayedComponents: [.date])
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .environment(\.locale, Locale(identifier: "En"))
                }
                
                
                Toggle(isOn: $newTitle.notifyTime) {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.purple)
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fit)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Time")
                                .fontWeight(.semibold)
                            if newTitle.notifyTime {
                                Text(newTitle.time, style: .time)
                                    .environment(\.locale, Locale(identifier: "En"))
                                    .font(.footnote)
                            }
                        }
                    }
                }
                .toggleStyle(SwitchToggleStyle())
                .contentShape(Rectangle())
                .onTapGesture {
                    if newTitle.notifyTime {
                        self.timeTapped.toggle()
                        self.dayTapped = false
                    }
                }
                
                .onChange(of: newTitle.notifyTime, perform: { value in
                    if value {
                        self.newTitle.notifyDay = true
                        self.dayTapped = false
                        self.timeTapped = true
                        
                    }else {
                        self.timeTapped = false
                    }
                })

                if newTitle.notifyTime && timeTapped {
                    DatePicker("Choose a time", selection: $newTitle.time, displayedComponents: [.hourAndMinute])
                        .datePickerStyle(WheelDatePickerStyle())
                        .environment(\.locale, Locale(identifier: "En"))
                        .labelsHidden()
                }
            }
        }
        .zIndex(1)
        .navigationTitle(newTitle.title.isEmpty ? "Note title" : newTitle.title)
        .navigationBarTitleDisplayMode(.inline)
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
struct NewNote_Previews: PreviewProvider {
    static var previews: some View {
        NewNote(newTitle: .constant(Notes.Data.init(title: "Note 1",
                                                    detail: "Note 1 detail about something",
                                                    day: Date(),
                                                    time: Date(),
                                                    notifyDay: true,
                                                    notifyTime: true,
                                                    isComplete: false)))
    }
}
