//
//  AddProgrammView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 28.01.2023.
//

import SwiftUI

struct AddProgrammView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchWord = ""
    @State private var mainNavigationSelector:Bool = false
    @State private var contentSize: CGSize = .zero
    @EnvironmentObject var viewModel:GymViewModel
    @State private var didTap:Bool = false
    @State private var exercisePos = 0
    @State private var programmPos = GymViewModel().screenWidth
    @State var shouldHideButton:Bool = true
    var body: some View {
        VStack {
            HStack{
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
                    .foregroundColor(.gray)
                    .padding([.leading,.top,.bottom],10)
                
                TextField("Find:", text: $searchWord)
                    .foregroundColor(.gray)
                    .tint(.gray)
                    .font(.custom("Helvetica", size: 20))
                    .fontWeight(.black)
                
                
            }
            .background(Rectangle()
                .cornerRadius(viewModel.viewCornerRadiusSimple)
                .foregroundColor(viewModel.systemColorLightGray))
            .padding([.top,.bottom], 2)
            .padding([.leading,.trailing], 10)
            
            HStack{
                Button("Exercises") {
                    //If exercises button hasn't tapped yet
                    if didTap == true {
                        
                        withAnimation(.spring()){
                            didTap.toggle()
                        }
                        
                        
                    }
                }
                
                .frame(width: 125,height: 35)
                .foregroundColor(didTap ? .gray : .white)
                .font(.custom("Helvetica", size: 20))
                .fontWeight(.black)
                .padding([.top,.bottom],10)
                .padding([.leading,.trailing],30)
                
                
                .background(Rectangle()
                    .foregroundColor(didTap ? .white : .black)
                    .cornerRadius(10)
                )
                
                Button("Programms") {
                    
                    //If programms button hasn't tapped yet
                    if didTap == false {
                        withAnimation(.spring()){
                            didTap.toggle()
                        }
                    }
                    
                    
                }
                .frame(width: 125,height: 35)
                .foregroundColor(didTap ? .white : .gray)
                .font(.custom("Helvetica", size: 20))
                .fontWeight(.black)
                .padding([.top,.bottom],10)
                .padding([.leading,.trailing],30)
                
                
                .background(Rectangle()
                    .foregroundColor(didTap ? .black : .white)
                    .cornerRadius(10)
                )
            }
            
            .padding(10)
            // List of types Execises, Tappable, it has behavior like Navitation Link
            if !didTap {
                ScrollView {
                    ViewExerciseList(toggleArray: $viewModel.selectedExArray, shouldHideButton: $viewModel.isSelectedSomeExercise).environmentObject(viewModel)
                        .overlay(
                            GeometryReader { geo in
                                Color.clear.onAppear {
                                    contentSize = geo.size
                                }
                            }
                        )
                        .frame(width: viewModel.screenWidth,height: 600)
                        .transition(.move(edge: .leading))
                        
                    
                }
                .frame(maxWidth: contentSize.width, maxHeight: contentSize.height)
                .transition(.move(edge: .leading))
                Button("Ready") {
                    
                }.buttonStyle(GrowingButton())
                    .tint(.white)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .offset(x:0,y:-20)
                    .opacity(viewModel.isSelectedSomeExercise ? 1 : 0)
                    
            } else {
                ViewProgrammsList()
                .transition(.move(edge: .trailing))
            }
            
            
            
        }
        .background(.white)
        .position(x: viewModel.screenWidth / 2,y:400)
    }
    
}










struct AddProgrammView_Previews: PreviewProvider {
    static var previews: some View {
        AddProgrammView().environmentObject(GymViewModel())
    }
}
