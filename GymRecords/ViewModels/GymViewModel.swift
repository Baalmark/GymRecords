

import SwiftUI


class GymViewModel: ObservableObject {
    
    @Published private(set) var gymModel: GymModel
    var selectedExArray:[Exercise]
    
    
    var exerciseList:[GymModel.TypeOfExercise] = GymModel.TypeOfExercise.allExercises
    var programmList:[GymModel.Programm] = GymModel.programms
    var imagesArray:[UIImage] = []
    var stringExerciseList:[String] = []
    var arrayExercises:[Exercise] = GymModel.arrayOfAllCreatedExercises
    //Design Vars
    var viewCornerRadiusSimple:CGFloat = 10
    //Colors
    
    var systemColorLightGray = Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
    var systemColorGray = Color(UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1))
    var systemColorMidGray = Color(UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1))
    
    var circleColor = Color(UIColor(white: 1, alpha: 0.1))
    var screenWidth = UIScreen.main.bounds.width
    var paddingSafeArea = 20
    
    init() {
        self.gymModel = GymModel(programmTitle: GymModel.Programm(programmTitle: "Test", countOfExcercises: 0, description: "", colorDesign: "White"))
        self.selectedExArray = []
    }
    
    
    public func appendImagesToArray(image img:UIImage) {
        imagesArray.append(img)
    }
    
    func getListOfExercises(){
        
        for element in exerciseList {
            stringExerciseList.append(element.rawValue)
        }
    }
    
    
    func selectingExercise(exercise:Exercise,isSelected:Bool) {
        
        selectedExArray = selectedExArray.filter({$0.name != exercise.name})
        let newItem = Exercise(type: exercise.type, name: exercise.name, doubleWeight: exercise.doubleWeight, selfWeight: exercise.selfWeight, isSelected: isSelected)
        selectedExArray.append(newItem)
        
        
        
        for i in selectedExArray {
            print(i.name,i.isSelected)
        }
        print("")
        
    }
    func unselectingExercise(exercise:Exercise,isSelected:Bool) {
        selectedExArray = selectedExArray.filter({$0.name != exercise.name})
        
        for i in selectedExArray {
            print(i.name,i.isSelected)
        }
        print("")
        
    }
    
    func clearArrayOfSelectedExercises() {
        selectedExArray.removeAll()
    }
    
//Finder of Exercise by title
    func findExerciseByTitle(title:String) -> Exercise? {
        for element in arrayExercises {
            if element.name == title {
                return element
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
