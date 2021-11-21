//
//  LaunchView.swift
//  Note
//
//  Created by Murat Haktanır on 19.11.2021.
//

import SwiftUI

struct LaunchView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isLoading: Bool
    var body: some View {
        if isLoading{
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(12)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.6), radius: 2, x: -5, y: 3)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .light ? .blue : .red))
                    .padding()
            }
            .onAppear {fakeLoading()}
            .zIndex(1)
        }
    }
    func fakeLoading() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isLoading = false
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(isLoading: .constant(true))
    }
}
