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
                }
                Section(header: Text("Calendar & Time")) {
                    HStack {
                        DatePicker("", selection: $note.day, displayedComponents: [.date])
                            .environment(\.locale, Locale(identifier: "En"))
                            .labelsHidden()
                        Spacer()
                        DatePicker("", selection: $note.time, displayedComponents: [.hourAndMinute])
                            .environment(\.locale, Locale(identifier: "En"))
                            .labelsHidden()
                    }
                    
                    HStack {
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
                                .font(.title3)
                        })
                            .buttonStyle(PlainButtonStyle())
                        
                        Text(note.isComplete ? "Completed." : "Not yet.")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(note.isComplete ? .green : .red)
                        
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
