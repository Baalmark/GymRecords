//
//  GymCalendarView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 20.01.2023.
//

import SwiftUI

struct GymCalendarView: UIViewRepresentable {
    
    
    
    
    let interval:DateInterval
    @ObservedObject var eventStore: EventStore
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        return view
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, eventStore: _eventStore)
    }

    class Coordinator: NSObject, UICalendarViewDelegate {
        
        var parent:GymCalendarView
        @ObservedObject var eventStore:EventStore
        
        init(parent: GymCalendarView, eventStore: ObservedObject<EventStore>) {
            self.parent = parent
            self._eventStore = eventStore
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            
            return nil
        }
    }
    
}













//
//struct GymCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        GymCalendarView()
//    }
//}
