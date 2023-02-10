//
//  ViewExerciseList.swift
//  GymRecords
//
//  Created by Pavel Goldman on 31.01.2023.
//

import SwiftUI

struct ViewExerciseList: View {
    
    @EnvironmentObject var viewModel:GymViewModel
    
    @State var isTapped = false
    @State var selectedExer: GymModel.TypeOfExercise? = nil
    @State var showOverlay = false
    @Binding var toggleArray:[Exercise]
    @State var backButtonLabel:String = ""
    @State var selectedExerciseArrayTitle:[Int] = []
    @Binding var shouldHideButton:Bool
    var body: some View {
        NavigationView{
            VStack {
                // Exercise Button
                Button {
                    
                } label: {
                    Text("Create Exercise")
                        .font(.custom("Helvetica", size: 22))
                        .fontWeight(.bold)
                    Spacer()
                    Text("+")
                        .fontWeight(.regular)
                }
                .foregroundColor(.black)
                .font(.custom("Helvetica", size: 26))
                .fontWeight(.bold)
                .padding(.trailing,10)
                .padding(20)
                .background(Rectangle()
                    .foregroundColor(Color("LightGrayColor"))
                    .frame(width: viewModel.screenWidth - 20, height: 60)
                    .cornerRadius(10))
                .padding(10)
                
                //List of exercises
                
                VStack() {
                    
                    ForEach(Array(viewModel.exerciseList.enumerated()), id:\.offset) {index,elem in
                        HStack{
                            
                            Image(elem.rawValue)
                            Text(elem.rawValue.capitalized)
                                .padding(.leading,10)
                                .frame(width: 110,height: 50,alignment: .leading)
                                .foregroundColor(.black)
                                .font(.custom("Helvetica", size: 20))
                                .fontWeight(.bold)
                            
                            
                            Spacer()
// Display count of exercise and selected exercise if they are there
                            HStack {
                                if selectedExerciseArrayTitle.isEmpty { // If selected exercise dont exist
                                    Text("\(viewModel.findNumberOfExerciseOneType(type: elem, array: viewModel.arrayExercises))")
                                        .font(.custom("Helvetica", size: 18))
                                } else {
                                    if selectedExerciseArrayTitle[index] == 0 { // If selected exercises dont exist in some category
                                        Text("\(viewModel.findNumberOfExerciseOneType(type: elem, array: viewModel.arrayExercises))")
                                            .font(.custom("Helvetica", size: 18))
                                    } else { // Display selected exercises
                                        Text("Selected: \(selectedExerciseArrayTitle[index])")
                                            .font(.custom("Helvetica", size: 18))
                                    }
                                }
                                    Image(systemName: "greaterthan")
                                        .font(.footnote)
                        
                            }
                            .foregroundColor(Color("GrayColor"))
                            .fontWeight(.bold)
                            
                        }
                        .padding([.leading,.trailing],30)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                        )
                        .onTapGesture {                            
                            self.selectedExer = elem
                            isTapped = true
                        }
                        .sheet(item: self.$selectedExer) { selected in
                            
                            ViewListSpecificExercises(backButtonLabel: $backButtonLabel, toggleArray: $toggleArray,
                                                      typeOfExercise: selected,isPresented: $isTapped,
                                                      selectedExerciseArray:$selectedExerciseArrayTitle).environmentObject(viewModel)
                                
                            
                        }
                    }
                }
                
                Spacer()
                
                
            }
        }
    }
    
}











struct ViewExerciseList_Previews: PreviewProvider {
    static var previews: some View {
        ViewExerciseList(toggleArray: .constant([]), shouldHideButton: .constant(true)).environmentObject(GymViewModel())
    }
}
