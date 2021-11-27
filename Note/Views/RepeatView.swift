//
//  RepeatView.swift
//  Note
//
//  Created by Murat Haktanır on 23.11.2021.
//

import SwiftUI

enum Repeatss: String, CaseIterable, Identifiable {
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
    
    var id: Repeatss { self }
}

struct RepeatView: View {
    @State private var repeatOptions: Repeatss = Repeatss.Newer
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
    var body: some View {
        List {
            ForEach(Repeatss.allCases, id: \.self) { item in
                Text(item.rawValue)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct RepeatView_Previews: PreviewProvider {
    static var previews: some View {
        RepeatView()
    }
}
