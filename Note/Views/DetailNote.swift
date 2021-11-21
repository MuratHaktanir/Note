//
//  DetailNote.swift
//  Note
//
//  Created by Murat Haktanır on 15.11.2021.
//

import SwiftUI

struct DetailNote: View {
    // MARK: - Properties
    @Binding var note: Notes
    @State private var notificationContent : UNNotificationContent?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State var dayTapped = false
    @State var timeTapped = false
    // MARK: - Body
    var body: some View {
        
        let notiName = "muradi"
        let pub = NotificationCenter.default.publisher(
            for: Notification.Name(notiName))
            Form {
                Section(header: Text(note.notifyDay ? "Edit your note: \(note.time, style: .time)" : "Edit your note")) {
                    
                    TextField("Your note", text: $note.title)
                    TextEditor(text: $note.detail)
                        .foregroundColor(.secondary)
                    HStack{
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.note.isComplete.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }, label: {
                            Image(systemName: note.isComplete ? "checkmark.circle" : "circle")
                                .foregroundColor(note.isComplete ? .green : .red)
                                .font(.title)
                        })
                            .buttonStyle(PlainButtonStyle())
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Complete?")
                                .font(.footnote)
                            Text(note.isComplete ? "Completed." : "Not yet.")
                                .font(.body)
                                .fontWeight(.semibold)
                            .foregroundColor(note.isComplete ? .green : .red)
                        }
                        
                        
                    }
                }
                .modifier(DismissingKeyboard())
                    Section(header: Text("Calendar & Time")) {
                        
                        Toggle(isOn: $note.notifyDay) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.purple)
                                    .imageScale(.large)
                                    .aspectRatio(contentMode: .fit)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Calendar")
                                        .fontWeight(.semibold)
                                    if note.notifyDay {
                                        Text(note.day, formatter: dateFormatter)
                                            .environment(\.locale, Locale(identifier: "En"))
                                            .font(.footnote)
                                    }
                                }
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if note.notifyDay {
                                self.dayTapped.toggle()
                            }
                        }
                        .onChange(of: note.notifyDay, perform: {value in
                            if value {
                                self.dayTapped = true
                            }else {
                                self.note.notifyTime = false
                                self.timeTapped = false
                            }
                        })
                        
                        if note.notifyDay && dayTapped {
                            DatePicker("Choose a day", selection: $note.day, displayedComponents: [.date])
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .environment(\.locale, Locale(identifier: "En"))
                        }
                        
                        
                        Toggle(isOn: $note.notifyTime) {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.purple)
                                    .imageScale(.large)
                                    .aspectRatio(contentMode: .fit)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Time")
                                        .fontWeight(.semibold)
                                    if note.notifyTime {
                                        Text(note.time, style: .time)
                                            .environment(\.locale, Locale(identifier: "En"))
                                            .font(.footnote)
                                    }
                                }
                            }
                        }
                        .toggleStyle(SwitchToggleStyle())
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if note.notifyTime {
                                self.timeTapped.toggle()
                                self.dayTapped = false
                            }
                        }
                        
                        .onChange(of: note.notifyTime, perform: { value in
                            if value {
                                self.note.notifyDay = true
                                self.dayTapped = false
                                self.timeTapped = true
                                
                            }else {
                                self.timeTapped = false
                            }
                        })

                        if note.notifyTime && timeTapped {
                            DatePicker("Choose a time", selection: $note.time, displayedComponents: [.hourAndMinute])
                                .datePickerStyle(WheelDatePickerStyle())
                                .environment(\.locale, Locale(identifier: "En"))
                                .labelsHidden()
                        }
                        
                        HStack {
                            Spacer()
                            Button("Reschedule") {
                                let calendar = Calendar.current
                                let components = calendar.dateComponents([.hour, .minute], from: note.time )
                                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                                NotificationHandler.shared.addNotification(id: notiName, title: note.title, subtitle: note.detail, trigger: trigger)
                                
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            .buttonStyle(PlainButtonStyle())
                            .foregroundColor(.blue)
                        }
                    }
                
            }
            .zIndex(1)
            .navigationTitle(note.title)
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(pub) { data in
                if let content = (data.object as? UNNotificationContent){
                    self.notificationContent = content
                    
                }
            }
            .background(Color(colorScheme == .light ? .systemFill : .opaqueSeparator).ignoresSafeArea())
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
struct DetailNote_Previews: PreviewProvider {
    static var previews: some View {
        DetailNote(note: .constant(Notes(
            title: "Note 1",
            detail: "Note 1 detail about something",
            day: Date(),
            time: Date(),
            notifyDay: true,
            notifyTime: true, isComplete: false)))
    }
}

//
//Section(header: Text("Calendar & Time")) {
//
//
//}
