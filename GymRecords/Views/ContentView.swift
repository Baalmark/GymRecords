//
//  ContentView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 14.01.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var width = UIScreen.main.bounds.size.width
    @State private var height:CGFloat = 325
    @State private var delta:CGFloat = 0
    @State private var viewState = CGSize.zero
    @State private var appearSheet = false
    
    
    private var maxHeight:CGFloat = 500
    private var minHeight:CGFloat = 325
    private var systemColor = Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
    private var systemShadowColor = Color(UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1))
    @StateObject private var viewModel = GymViewModel()
    
    @EnvironmentObject var eventStore: EventStore
    
    var body: some View {
        ZStack {
            NavigationStack{
                VStack{
                    
                    VStack(alignment: .center){
                        Spacer(minLength: 90)
                        GymCalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), eventStore: eventStore)
                            .frame(width: width, height:  height <= maxHeight ? height : maxHeight  ,alignment: .top)
                            .environmentObject(viewModel)
                            .clipShape(Rectangle())
                            .shadow(color: .black,radius: 1)
                            
                            
                        Spacer(minLength: 5)
                        //Little button for unwrapping the Calendar View
                        VStack{
                            Text("")
                                .background(Rectangle()
                                    .frame(width: 150,height: 10)
                                    .foregroundColor(systemColor)
                                    .border(.white,width: 2.5)
                                )
                            
                            Text("")
                                .background(Rectangle()
                                    .frame(width: width,height: 15)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(color: systemShadowColor, radius: 5,x: 0,y: 9)
                                )
                        }
                        //Gesture for unwrapping the Calendar View
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    viewState = value.translation
                                    height = max(100, height + viewState.height)
                                    
                                }
                                .onEnded { value in
                                    self.viewState = .zero
                                    if height > maxHeight {
                                        height = maxHeight
                                    } else if height <= minHeight {
                                        height = minHeight
                                    }
                                    
                                })
                        Spacer(minLength: 15)
                        // Background Image
                        Image("backgroundMain")
                        
                        Button("Add Programm") {
                            appearSheet.toggle()
                        }
                        .sheet(isPresented:$appearSheet) {
                            AddProgrammView()
                        }
                        .buttonStyle(GrowingButton())
                        .tint(.white)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .position(x:width/2,y: height <= maxHeight ? 550 + (-height) : 50)
                        
                    }
                    
                    .position(x:197.5,y: height <= maxHeight ? -400 + height : 100)
                    .frame(width: width, height: height <= maxHeight ? height : maxHeight, alignment: .center)
                    
                    
                    
                    
                }
                
                
                .navigationBarTitleDisplayMode(.large)
// Navigation toolbar
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        
                        Text("Today")
                            .font(.custom("Helvetica", fixedSize: 35))
                            .bold()
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {}) {
                            Image("weight_addProgramm")
                                .resizable()
                                .frame(width: 35,height: 35)
                        }}
                    
                }
                
            }
            .environmentObject(viewModel)
        }
        
    }
    
    }



//Style of bottom Button
struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 335,height: 45)
            .background(.black)
            .foregroundColor(.white)
            .clipShape(Rectangle())
            .cornerRadius(15)
            .shadow(color: .gray, radius: 3)
            .scaleEffect(configuration.isPressed ? 1.5 : 1)
            .animation(.easeOut(duration: 0.33), value: configuration.isPressed)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(EventStore(preview: true))
    }
}

