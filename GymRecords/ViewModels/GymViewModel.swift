

import SwiftUI


class GymViewModel: ObservableObject {
    
    @Published private(set) var gymModel: GymModel
    
    var exerciseList:[GymModel.TypeOfExercise] = GymModel.TypeOfExercise.allExercises
    var imagesArray:[UIImage] = []
    var stringExerciseList:[String] = []
    
    init() {
        self.gymModel = GymModel(programmTitle: GymModel.Programm(programmTitle: "Test", countOfExcercises: 0, description: "", colorDesign: "White"))
    }
    
    
    public func appendImagesToArray(image img:UIImage) {
        imagesArray.append(img)
    }
    
    func getListOfExercises(){
        
        for element in exerciseList {
            stringExerciseList.append(element.rawValue)
        }
    }
    
    
    func someTest() {
        
        print("Testing")
        
    }
}

