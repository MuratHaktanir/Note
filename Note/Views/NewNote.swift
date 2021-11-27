//
//  NewNote.swift
//  Note
//
//  Created by Murat Haktanır on 15.11.2021.
//

import SwiftUI

enum Repeats: String, CaseIterable, Identifiable {
    case Newer,
         Weekdays,
         Weekends,
         Weekly,
         Biweekly,
         Monthly,
         Every3Months = "Every 3 Months",
         Every6Months = "Every 6 Months",
         Yearly,
         Custom
    
    var id: Repeats { self }
}


struct NewNote: View {
    // MARK: - Properties
    @Binding var newTitle: Notes.Data
    @State var dayTapped = false
    @State var timeTapped = false
    @Environment(\.colorScheme) var colorScheme
    
    @State private var repeatOptions: Repeats = Repeats.Newer
    var repeatNames: String {
        switch repeatOptions {
        case .Newer:
            return "Newer"
        case .Weekdays:
            return "Weekdays"
        case .Weekends:
            return "Weekends"
        case .Weekly:
            return "Weekly"
        case .Biweekly:
            return "Biweekly"
        case .Monthly:
            return "Monthly"
        case .Every3Months:
            return "Every 3 Months"
        case .Every6Months:
            return "Every 6 Months"
        case .Yearly:
            return "Yearly"
        case .Custom:
            return "Custom"
        }
    }
        
    
    
    var endRepeat = [
                    "Repeat Forever",
                    "End Repeat Date"
    ]
    
    // MARK: - Body
    var body: some View {
        ZStack {
            //            Color(colorScheme == .light ? .systemFill : .opaqueSeparator).ignoresSafeArea()
            Form {
                Section(header: Text("Taking note")) {
                    TextField("Add a note", text: $newTitle.title)
                    TextEditor(text: $newTitle.detail)
                        .foregroundColor(.secondary)
                        .font(.callout)
                }
                .modifier(DismissingKeyboard())
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
                    .onChange(of: newTitle.notifyDay, perform: {value in
                        if value {
                            self.dayTapped = true
                        }else {
                            self.newTitle.notifyTime = false
                            self.timeTapped = false
                        }
                    })

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
                
                Section {
                    if newTitle.notifyDay {
                        HStack {
                            Image(systemName: "repeat.circle.fill")
                                .font(.title3)
                                .foregroundColor(.purple)
                            Text("Repeats")
                            Spacer()
                            Picker("", selection: $repeatOptions, content: {
                                ForEach(Repeats.allCases) { item in
                                    Text(item.rawValue)
                                }
                            })
                        }
                    }
                }
                .zIndex(0.8)
            }
            .zIndex(1)
            .navigationTitle(newTitle.title.isEmpty ? "Note title" : newTitle.title)
            .navigationBarTitleDisplayMode(.inline)
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
