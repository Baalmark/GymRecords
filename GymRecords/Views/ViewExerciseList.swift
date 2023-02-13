//
//  ViewExerciseList.swift
//  GymRecords
//
//  Created by Pavel Goldman on 31.01.2023.
//

import SwiftUI

struct ViewExerciseList: View {
    
    @EnvironmentObject var viewModel:GymViewModel
    @Environment(\.dismiss) var dismiss
    @State var withCategory:Bool
    @State var isTapped = false
    @State var selectedExer: GymModel.TypeOfExercise? = nil
    @State var showOverlay = false
    @Binding var toggleArray:[Exercise]
    @State var backButtonLabel:String = ""
    @State var selectedExerciseArrayTitle:[Int] = []
    @Binding var shouldHideButton:Bool
    @State var isShowCreateExercise = false
    var body: some View {
        NavigationView{
            VStack {
                // Exercise Button
                if withCategory {
                    ButtonCreateExercise(showCreateExercise: $isShowCreateExercise)
                } else {
                    //Close button
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            
                            .foregroundColor(Color("LightGrayColor"))
                            .tint(.white)
                            .fixedSize()
                            .font(.title2)
                    }
                    .offset(x:viewModel.screenWidth / 2,y:0)
                    .padding(.trailing,70)
                    .padding(.bottom,50)
                    
                }
                //List of exercises
                
                VStack() {
                    
                    ForEach(Array(viewModel.exerciseList.enumerated()), id:\.offset) {index,elem in
                        HStack{
                            
                            Image(elem.rawValue)
                            Text(elem.rawValue.capitalized)
                                .padding(.leading,10)
                                .frame(width: 110,height: 50,alignment: .leading)
                                .foregroundColor(withCategory ? .black : .white)
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
                            .foregroundColor(withCategory ? Color("MidGrayColor") : .white)
                            .fontWeight(.bold)
                            
                        }
                        .padding([.leading,.trailing],30)
                        .padding(.bottom,withCategory ? 0 : 10)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(withCategory ? .white : Color("backgroundDarkColor"))
                        )
                        .onTapGesture {                            
                            self.selectedExer = elem
                            isTapped = true
                        }
                        .fullScreenCover(item: self.$selectedExer) { selected in
                            if withCategory {
                                
                                ViewListSpecificExercises(backButtonLabel: $backButtonLabel, toggleArray: $toggleArray,
                                                          typeOfExercise: selected,isPresented: $isTapped,
                                                          selectedExerciseArray:$selectedExerciseArrayTitle).environmentObject(viewModel)
                            } else {
                                CreateNewExercise(typeOfExercise: selected, showView: $isTapped).environmentObject(viewModel)
                            }
                                
                            
                        }
                       
                    }
                }
                
                Spacer()
                
                
            }
            .background(withCategory ? .white : Color("backgroundDarkColor"))
        }
    }
    
}











struct ViewExerciseList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ViewExerciseList(withCategory: true, toggleArray: .constant([]), shouldHideButton: .constant(true)).environmentObject(GymViewModel())
            
            ViewExerciseList(withCategory: false, toggleArray: .constant([]), shouldHideButton: .constant(true)).environmentObject(GymViewModel())
            
        }
    }
}
