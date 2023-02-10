

import SwiftUI


class GymViewModel: ObservableObject {
    
    @Published private(set) var gymModel: GymModel
    @Published var isSelectedSomeExercise:Bool = false
    @Published var changeExercisesDB:Bool = false
    var selectedExArray:[Exercise]
    var trainingPlannedArray:[GymModel.TrainingInfo]
    var databaseInfoTitle:[(String,Int)]
    
    var exerciseList:[GymModel.TypeOfExercise] = GymModel.TypeOfExercise.allExercises
    var programList:[GymModel.Program] = GymModel.programs
    var imagesArray:[UIImage] = []
    var stringExerciseList:[String] = []
    var arrayExercises:[Exercise] = GymModel.arrayOfAllCreatedExercises
    
    //Computed Property
    var selectedCounterLabel:[Int] {
        var array:[Int] = []
        for element in exerciseList {
            let result = findNumberOfSelectedExerciseByTypeVM(
                type: element, array: arrayExercises)
            array.append(result)
            
        }
        return array
    }
    

    
    
    
    //Design Vars
    var viewCornerRadiusSimple:CGFloat = 10
    var screenWidth = UIScreen.main.bounds.width
    var paddingSafeArea = 20
    
    init() {
        self.gymModel = GymModel(programTitle: GymModel.Program(programTitle: "Test", countOfExcercises: 0, description: "", colorDesign: "White"))
        self.selectedExArray = []
        self.trainingPlannedArray = [GymModel.TrainingInfo(name: "FirstTrain", arrayOfExercises: arrayExercises, Date: .distantPast)]
        self.databaseInfoTitle = [("WorkOut",trainingPlannedArray.count),("Programs",programList.count),("Exercises",arrayExercises.count)]
    }
    
    
    public func appendImagesToArray(image img:UIImage) {
        imagesArray.append(img)
    }
//List of exercise types
    func getListOfExercises(){
        for element in exerciseList {
            stringExerciseList.append(element.rawValue)
        }
    }
    
//Exercise selection
    func selectingExercise(exercise:Exercise,isSelected:Bool) {
        
        selectedExArray = selectedExArray.filter({$0.name != exercise.name})
        let newItem = Exercise(type: exercise.type, name: exercise.name, doubleWeight: exercise.doubleWeight, selfWeight: exercise.selfWeight, isSelected: isSelected)
        selectedExArray.append(newItem)
        
        for (i,element) in arrayExercises.enumerated() {
            if element.isSelected != newItem.isSelected, element.name == newItem.name {
                arrayExercises[i].isSelected = newItem.isSelected
            }
        }
        
        for i in selectedExArray {
            print(i.name,i.isSelected)
        }
        
    }
//Exercise unselection
    func unselectingExercise(exercise:Exercise,isSelected:Bool) {
        let newItem = Exercise(type: exercise.type, name: exercise.name, doubleWeight: exercise.doubleWeight, selfWeight: exercise.selfWeight, isSelected: isSelected)

        selectedExArray = selectedExArray.filter({$0.name != exercise.name})
        
        for (i,element) in arrayExercises.enumerated() {
            if element.isSelected != newItem.isSelected, element.name == newItem.name {
                arrayExercises[i].isSelected = newItem.isSelected
            }
        }
        
        
        for i in selectedExArray {
            print(i.name,i.isSelected)
        }
        
        
    }
    
//Find a number of exercise same type.
    func findNumberOfExerciseOneType(type:GymModel.TypeOfExercise,array:Array<Exercise>) -> Int {
        return gymModel.findNumberOfExerciseOneType(type: type, array: array)
    }
    
//Find a number of selected Exercise by type of exercise (VM - ViewModel )
    func findNumberOfSelectedExerciseByTypeVM(type:GymModel.TypeOfExercise,array:Array<Exercise>) -> Int {
        return gymModel.findNumberOfSelectedExerciseByType(type: type, array: array)
    }
    
    
//Remove some exercise by user's choice
    func removeSomeExercise(exercise:Exercise) {
        let newArray = gymModel.removeSomeExerciseFromArray(exercise: exercise, array: arrayExercises)
        
        arrayExercises = newArray
        //Reload info for DataBaseTitle Exercise Counter
        databaseInfoTitle = [("WorkOut",trainingPlannedArray.count),("Programms",programList.count),("Exercises",arrayExercises.count)]
    }
    
//Change settings of exerise by toggle.
    func toggleBodyAndDoubleWeight(exercise:Exercise,bodyWeight:Bool,doubleWeight:Bool) {
       let newExercise = gymModel.modelToggleBodyAndDoubleWeight(exercise:exercise,bodyWeight:bodyWeight,doubleWeight:doubleWeight)
        let newArray = gymModel.replaceExerciseInArray(exercise: newExercise, array: arrayExercises)
        arrayExercises = newArray
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
