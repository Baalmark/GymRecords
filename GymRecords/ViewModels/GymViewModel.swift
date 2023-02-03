

import SwiftUI


class GymViewModel: ObservableObject {
    
    @Published private(set) var gymModel: GymModel
    @Published var selectedExercise:[GymModel.SelectedExercises] = []
    
    var exerciseList:[GymModel.TypeOfExercise] = GymModel.TypeOfExercise.allExercises
    var programmList:[GymModel.Programm] = GymModel.programms
    var imagesArray:[UIImage] = []
    var stringExerciseList:[String] = []
    var arrayExercises:[GymModel.Exercise] = GymModel.arrayOfAllCreatedExercises
 
    //Design Vars
    var viewCornerRadiusSimple:CGFloat = 10
    var systemColorLightGray = Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
    var systemColorGray = Color(UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1))
    var circleColor = Color(UIColor(white: 1, alpha: 0.1))
    var screenWidth = UIScreen.main.bounds.width
    var paddingSafeArea = 20
    
    init() {
        self.gymModel = GymModel(programmTitle: GymModel.Programm(programmTitle: "Test", countOfExcercises: 0, description: "", colorDesign: "White"), arrayOfAllCreatedExercises: [])
        self.selectedExercise = []
    }
    
    
    public func appendImagesToArray(image img:UIImage) {
        imagesArray.append(img)
    }
    
    func getListOfExercises(){
        
        for element in exerciseList {
            stringExerciseList.append(element.rawValue)
        }
    }
    
    
    func appendToArrayOfSelectedExercises(name:String,type t:GymModel.TypeOfExercise) {
        let newElement = GymModel.SelectedExercises(title: name, type: t)
        gymModel.addSelectedExerciseIntoArray(exercise: newElement)
        selectedExercise = gymModel.selectedExercises
        
        
    }
    
    func clearArrayOfSelectedExercises() {
        selectedExercise.removeAll()
    }
    
//Finder of Exercise by title
    func findExerciseByTitle(title:String) -> GymModel.Exercise? {
        for arrayExercise in arrayExercises {
            if arrayExercise.name == title {
                return arrayExercise
            }
        }
        return nil
    }
}

//MARK: Extensions

extension Color {
    static subscript(name: String) -> Color {
        switch name {
        case "green":
            return Color.green
        case "white":
            return Color.white
        case "black":
            return Color.black
        case "red":
            return Color.red
        case "gray":
            return Color.gray
        case "purple":
            return Color.purple
        case "yellow":
            return Color.yellow
        case "orange":
            return Color.orange
        case "blue":
            return Color.blue
        default:
            return Color.accentColor
        }
    }
}
