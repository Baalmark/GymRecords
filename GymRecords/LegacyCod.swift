//
//  LegacyCod.swift
//  GymRecords
//
//  Created by Pavel Goldman on 13.05.2023.
//

import Foundation


//
//@State var offset:CGFloat = 0
//    @Binding var exercises:[Exercise]
//
//    var body: some View {
//        GeometryReader { proxy in
//            let screenSize = proxy.size
//            ZStack(alignment: .top) {
//
//
//                //MARK: Page Tab View
//                TabView(selection: $exercises.first!){
//                    ForEach(exercises) { ex in
//                        GeometryReader{ proxy in
//                            let size = proxy.size
//                            Image("\(ex.type.rawValue)")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: size.width,height: size.height)
//                                .clipped()
//                        }
//                        .ignoresSafeArea()
//                        .offsetX { value in
//
//                            if exercises.first! == ex {
//                                offset = value - (screenSize.width * CGFloat(indexOf(tab: ex)))
//                            }
//                        }
//                        .tag(ex)
//                    }
//                }
//                .ignoresSafeArea()
//                .tabViewStyle(.page(indexDisplayMode: .never))
//                Text("\(offset)")
//                    .offset(y:400)
//
//            }
//            .frame(width: screenSize.width,height: screenSize.height)
//        }
//    }
//
//    @ViewBuilder
//    func DynamicTabHeader(size:CGSize)-> some View {
//        VStack(alignment: .leading,spacing: 22) {
//            Text("Dynamic Tabs")
//                .font(.title.bold())
//                .foregroundColor(.white)
//            HStack(spacing:0) {
//                ForEach(exercises) { ex in
//                    Text(ex.name)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                        .frame(maxWidth:.infinity)
//
//                }
//            }
//            .background(alignment: .bottomLeading) {
//                Capsule()
//                    .fill(.white)
//                //MARK: Dont Forget to Remove Your Padding in Screen Width
//                    .frame(width: (size.width - 30) / CGFloat(exercises.count),height: 4)
//                    .offset(y:12)
//                    .offset(x: tabOffset(size: size, padding: 30))
//            }
//
//        }
//        .frame(maxWidth: .infinity,alignment: .leading)
//        .padding(15)
//        .background {
//            Rectangle()
//                .fill(.ultraThinMaterial)
//                .environment(\.colorScheme, .dark)
//                .ignoresSafeArea()
//        }
//    }
//
//    //MARK: Tab Offset
//    func tabOffset(size: CGSize,padding:CGFloat) -> CGFloat {
//        return (-offset / size.width) * ((size.width - padding) / CGFloat(exercises.count))
//    }
//
//    //MARK: Tab Index
//    func indexOf(tab: Exercise) -> Int {
//        let index = exercises.firstIndex { CTab in
//            CTab == tab
//        } ?? 0
//
//        return index
//    }
//}
//
//    
