

import SwiftUI


class GymViewModel: ObservableObject {
    
    @Published private(set) var gymModel: GymModel
    @Published var isSelectedSomeExercise:Bool = false
    @Published var changeExercisesDB:Bool = false
    @Published var isDarkMode:Bool = false
    @Published var selectedExArray:[Exercise] = []
    @Published var databaseInfoTitle:[(String,Int)]
    @Published var backButtonLabel:String = ""
    @Published var programList:[GymModel.Program] = GymModel.programs
    
    
    var trainingPlannedArray:[GymModel.TrainingInfo]
    var colors = GymModel.colors
    var exerciseList:[GymModel.TypeOfExercise] = GymModel.TypeOfExercise.allExercises
    var imagesArray:[UIImage] = []
    var stringExerciseList:[String] = []
    var arrayExercises:[Exercise] = GymModel.arrayOfAllCreatedExercises
    
    //Computed Property
    @Published var selectedCounterLabel:[Int] = []
        
    

    
    
    
    //Design Vars
    var viewCornerRadiusSimple:CGFloat = 10
    var screenWidth = UIScreen.main.bounds.width
    var paddingSafeArea = 20
    
    init() {
        self.gymModel = GymModel(programTitle: GymModel.Program(programTitle: "Test", description: "", colorDesign: "White", exercises: GymModel.programs[0].exercises))
        self.selectedExArray = []
        self.trainingPlannedArray = [GymModel.TrainingInfo(name: "FirstTrain", arrayOfExercises: arrayExercises, Date: .distantPast)]
        self.databaseInfoTitle = [("WorkOut",trainingPlannedArray.count),("Programs",GymModel.programs.count),("Exercises",arrayExercises.count)]
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
    
//Compure selected Counter Label
    func computeSelectedCounderLabel() -> Array<Int> {
        var array:[Int] = []
        for element in exerciseList {
            let result = findNumberOfSelectedExerciseByTypeVM(
                type: element, array: arrayExercises)
            array.append(result)
            
        }
        return array
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
    }
    
//Couple exercises unselection
    func unselectingCoupleOfExercise(arrayOfTitles:[String] = [],arrayOfExercises:[Exercise] = [],isSelected:Bool) {
        
        if arrayOfExercises.isEmpty, !arrayOfTitles.isEmpty {
            var newArray:[Exercise] = []
            for element in arrayOfTitles {
                if let newElement = findExercise(name: element) {
                    newArray.append(newElement)
                }
            }
            
            for newElement in newArray {
                unselectingExercise(exercise: newElement, isSelected: isSelected)
            }
            
        } else if !arrayOfExercises.isEmpty{
            for element in arrayOfExercises {
                unselectingExercise(exercise: element, isSelected: isSelected)
            }
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
    }
    
//Find exercise from array by name
    func findExercise(name:String) -> Exercise?{
        for element in arrayExercises {
            if element.name == name {
                return element
            }
        }
        return nil
    }
    
    func clearSelectedExArray() {
        self.selectedExArray = []
        
        for (i,element) in arrayExercises.enumerated() {
            if element.isSelected == true {
                arrayExercises[i].isSelected = false
            }
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
        
        //Reload DB Info
        databaseInfoTitle = gymModel.reloadDataBaseInfo(trainArray: trainingPlannedArray, progArray: programList, arrayExercises: arrayExercises)
    }
    
//Change settings of exerise by toggle.
    func toggleBodyAndDoubleWeight(exercise:Exercise,bodyWeight:Bool,doubleWeight:Bool) {
       let newExercise = gymModel.modelToggleBodyAndDoubleWeight(exercise:exercise,bodyWeight:bodyWeight,doubleWeight:doubleWeight)
        let newArray = gymModel.replaceExerciseInArray(exercise: newExercise, array: arrayExercises)
        arrayExercises = newArray
    }
//Create a new Exercise
    func createNewExercise(exercise:Exercise) {
        let newArray = gymModel.createNewExercise(exercise: exercise, array: arrayExercises)
        arrayExercises = newArray
        
        //Reload DB Info
        databaseInfoTitle = gymModel.reloadDataBaseInfo(trainArray: trainingPlannedArray, progArray: programList, arrayExercises: arrayExercises)
    }
    
// Create a new program
    func createNewProgram(program:GymModel.Program) {
        var flag = false
        for (index,elements) in programList.enumerated() {
            if elements.programTitle == program.programTitle {
                programList[index] = program
                flag = true
            }
        }
        if flag == false {
            programList.append(program)
            gymModel.addProgram(program)
            //Reload DB Info
            databaseInfoTitle = gymModel.reloadDataBaseInfo(trainArray: trainingPlannedArray, progArray: programList, arrayExercises: arrayExercises)
        }
    }
//Remove some program
    
    func removeProgram(program:GymModel.Program) {
        
        for (index,element) in programList.enumerated() {
            if element.programTitle == program.programTitle {
                programList.remove(at: index)
                gymModel.removeProgram(index)
            }
        }
        
        
    }
}


//MARK: Extensions


//Subscripts color by string Color["Name"]
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
        case "cyan":
            return Color.cyan
        case "pink":
            return Color.pink
        case "indigo":
            return Color.indigo
        case "teal":
            return Color.teal
            
        default:
            return Color.accentColor
        }
    }
}
// Hide keyboard by touches outside
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
//Change color of TextField placeholder 
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
//MARK: Blurred Sheet Extension View
    func blurredSheet<Content:View>(_ style: AnyShapeStyle, show: Binding<Bool>,onDismiss:
                                    @escaping () -> (),@ViewBuilder content:@escaping ()->Content)->some View {
        self
            .sheet(isPresented: show, onDismiss: onDismiss) {
                content()
                    .background(RemovebackgroundColor())
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .background {
                        Rectangle()
                            .fill(style)
                            .ignoresSafeArea(.container,edges: .all)
                    }
            }
    }
}
//MARK: Remove background color
fileprivate struct RemovebackgroundColor: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
}

