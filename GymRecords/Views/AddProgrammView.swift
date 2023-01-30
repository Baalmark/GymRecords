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
    private var paddingSafeArea = 20
    @State private var viewModel = GymViewModel()
    //Variables for design
    private var viewCornerRadiusSimple:CGFloat = 10
    private var systemColor = Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
    private var screenWidth = UIScreen.main.bounds.width
    @State private var didTap:Bool = false
    
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
                .cornerRadius(viewCornerRadiusSimple)
                .foregroundColor(systemColor))
            .padding([.top,.bottom], 2)
            .padding([.leading,.trailing], 10)
            
            HStack{
                Button("Exercises") {
                    //If exercises button hasn't tapped yet
                    if didTap == true {
                        didTap.toggle()
                        
                        
                        
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
                        
                        didTap.toggle()
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
            
            List {
                ForEach(viewModel.exerciseList, id:\.id) {elem in
                    HStack{
                        Image(name:)
                        Text(elem.rawValue)
                            .frame(width: 50,height: 50)
                            .foregroundColor(.white)
                            .background(.black)
                        
                    }
                }
            }
            
            .background(.gray)
            
        }
        
        .position(x: screenWidth / 2,y:400)
    }
}










struct AddProgrammView_Previews: PreviewProvider {
    static var previews: some View {
        AddProgrammView()
    }
}
