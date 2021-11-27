//
//  DismissButtonForNote.swift
//  Note
//
//  Created by Murat Haktanır on 22.11.2021.
//

import SwiftUI

struct DismissButtonForNote: View {
    @Binding var isPresented: Bool
    @Binding var newTitle: Notes.Data
    var body: some View {
        Button(action: {
            isPresented = false
            self.newTitle.title = ""
            self.newTitle.detail = ""
        }) {
            Image(systemName: "xmark.circle")
                .font(.title3)
                .foregroundColor(.primary)
        }
    }
}

