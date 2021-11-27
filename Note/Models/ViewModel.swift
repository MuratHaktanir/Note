//
//  ViewModel.swift
//  Note
//
//  Created by Murat Haktanır on 23.11.2021.
//

import Foundation
import SwiftUI

final class ViewModel: ObservableObject {
    @Published var dayTapped = false
    @Published var timeTapped = false
}
