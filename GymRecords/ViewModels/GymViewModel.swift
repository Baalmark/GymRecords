

import SwiftUI


class GymViewModel: ObservableObject {
    
    @Published private(set) var gymModel: GymModel
    @Published var isSelectedSomeExercise:Bool = false
    @Published var changeExercisesDB:Bool = false
    @Published var isDarkMode:Bool = false
    @Published var selectedExArray:[Exercise] = []
    @Published var databaseInfoTitle:[(String,Int)]
    @Published var backButtonLabel:String = ""
    @Published var programList:[GymModel.Program]
    
    //Edit or Remove View appears and dissapears by these variables
    @Published var isShowedEditOrRemoveView:Bool = false
    @Published var showedEdirOrRemoveProgram:GymModel.Program
    
    //View List Specifi Exercise appears and dissapears by these variables
    @Published var isShowedViewListSpecificExercise:Bool = false
    @Published var showedViewListSpecificExercise:GymModel.TypeOfExercise = .arms
    @Published var isShowedCreateNewExerciseList:Bool = false
    
    //Passing Date for new Programm
    @Published var dateForProgramm:Date
    
    //Finder any Exercises
    @Published var searchWord:String = ""
    @Published var arrayOfFoundExercise:[Exercise] = []
    @Published var isSearching: Bool = false
    
    
    //Date holder
    @Published var date:Date
    @Published var arrayOfMonths:[Date] = []
    @Published var selectedDate:Date = Date() // Selected Date for new training day
    @Published var selectedDayForChecking:Int = 0
    @Published var selectedDayRowHolder = 0
    
    
    var colors = GymModel.colors
    var exerciseList:[GymModel.TypeOfExercise] = GymModel.TypeOfExercise.allExercises
    var imagesArray:[UIImage] = []
    var stringExerciseList:[String] = []
    var arrayExercises:[Exercise] = GymModel.arrayOfAllCreatedExercises
    
    
    
    //All property to creating a training day
    @Published var trainings:[String:GymModel.Program]
    @Published var selectedProgramForNewTrainingDay:GymModel.Program? = nil
    @Published var trainInSelectedDay:GymModel.Program
    //Computed Property
    @Published var selectedCounterLabel:[Int] = []
    
    //Computed or Store value of Delete / Create / Change a set for the exercise
    
    @Published var didTapToAddSet:Bool = false
    @Published var newSets:[Sets] = []
    
    //Show view with sets
    @Published var isShowedMainAddSetsView = false
    
    
    //Design Vars
    var viewCornerRadiusSimple:CGFloat = 10
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    var paddingSafeArea = 20
    
    init() {
        self.gymModel = GymModel()
        self.programList = GymModel().programs
        self.selectedExArray = []
        self.trainings = GymModel().trainingDictionary
        self.showedEdirOrRemoveProgram = GymModel().programs[0]
        self.databaseInfoTitle = [("WorkOut",GymModel().trainingDictionary.count),("Programs",GymModel().programs.count),("Exercises",arrayExercises.count)]
        //Date holder
        
        self.date = Date()
        self.dateForProgramm = Date.now
        self.arrayOfMonths = [CalendarModel().minusMonth(Date()),Date(),CalendarModel().plusMonth(Date())]
        
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date())
        selectedDayForChecking = components.day!
        trainInSelectedDay = GymModel.Program(programTitle: "blank", description: "blank", colorDesign: "red", exercises: [])
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
        let newItem = Exercise(type: exercise.type, name: exercise.name, doubleWeight: exercise.doubleWeight, selfWeight: exercise.selfWeight, isSelected: isSelected, sets: [], isSelectedToAddSet: false)
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
        let newItem = Exercise(type: exercise.type, name: exercise.name, doubleWeight: exercise.doubleWeight, selfWeight: exercise.selfWeight, isSelected: isSelected, sets: [], isSelectedToAddSet: false)
        
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
        databaseInfoTitle = gymModel.reloadDataBaseInfo(trainDictionary: trainings, progArray: programList, arrayExercises: arrayExercises)
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
        databaseInfoTitle = gymModel.reloadDataBaseInfo(trainDictionary: trainings, progArray: programList, arrayExercises: arrayExercises)
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
            databaseInfoTitle = gymModel.reloadDataBaseInfo(trainDictionary: trainings, progArray: programList, arrayExercises: arrayExercises)
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
    
    //Select programm for new training Day
    func selectingProgrammForNewTrainingDay(program:GymModel.Program) {
        selectedProgramForNewTrainingDay = program
    }
    
    //Find any exercises by search
    func findAnyExerciseByLetters(letters:String,array:[Exercise]) -> Array<Exercise>{
        return gymModel.finderByTextField(letters: letters, array: array)
    }
    //MARK: Behavior for the Calendar View
    //Enum of directions
    enum SwipeHVDirection: String {
        case left, right, up, down, none
    }
    //Detecting drag gesture directions
    
    func detectDirection(value: DragGesture.Value) -> SwipeHVDirection {
        if value.startLocation.x < value.location.x - 24 {
            return .left
        }
        if value.startLocation.x > value.location.x + 24 {
            return .right
        }
        if value.startLocation.y < value.location.y - 24 {
            return .down
        }
        if value.startLocation.y > value.location.y + 24 {
            return .up
        }
        return .none
    }
    //Updating array of months
    func updateArrayMonthsNext() {
        for (i,element) in arrayOfMonths.enumerated() {
            arrayOfMonths[i] = CalendarModel().plusMonth(element)
            
        }
        updateMonth()
    }
    func updateArrayMonthsBack() {
        for (i,element) in arrayOfMonths.enumerated() {
            arrayOfMonths[i] = CalendarModel().minusMonth(element)
            
        }
        updateMonth()
    }
    // Selecting new day for new training day
    func selectDayForTraining(day:Int) {
        //Update month
        updateMonth()
        selectedDate = CalendarModel().selectDay(date, day: day)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: selectedDate)
        selectedDayForChecking = components.day!
        
    }
    // Update month of current date
    
    func updateMonth() {
        date = arrayOfMonths[1]
    }
    
    // Is the correct day selected?
    func isSelectedDay(day:Int,date:Date) -> Bool {
        return selectedDayForChecking == day  && date == arrayOfMonths[1]
    }
    
    // Create new training day
    
    func createTraining(date:Date,exercises:[Exercise]){
        
        let stringDate = toStringDate(date: date)
        let newProgram = GymModel.Program(programTitle: "blank", description: "blank", colorDesign: "blank", exercises: exercises)
        trainings[stringDate] = newProgram
        trainInSelectedDay = newProgram
        
    }
    
    func createTraining(date:Date,program:GymModel.Program)  {
        
        let stringDate = toStringDate(date: date)
        trainings[stringDate] = program
        trainInSelectedDay = program
        
    }
    
    //Creating String of Date from Date
    func toStringDate(date:Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "y/M/d"
        return dateFormater.string(from: date)
    }
    
    //Checking the row for the selected day
    func checkTheRowForTheSelectedDay(correctDay:Int, month:Date) -> Bool{
        let components = selectedDate.get(.day, .month, .year)
        if components.day == correctDay && Calendar.current.isDate(selectedDate, equalTo: month, toGranularity: .month) {
                return true
        }
        return false
    }
    // The function that calculates with what coefficient to shift the calendar view when you use the drag gesture
    
    func getCoefficientOffset(row:Int) -> CGFloat {
        if let offset = CalendarMinimizingPosition(id: row) {
            return offset.rawValue
        }
        return CalendarMinimizingPosition.zero.rawValue
    }
    
    //Сheck for training availability on the selected day
    func isAnyTrainingSelectedDay() -> Bool {
        let stringDate = toStringDate(date: selectedDate)
        
        return trainings[stringDate] != nil
            
    }
    
    //Selecting the day with a training
    func selectingTheDayWithTraining() {
        let stringDate = toStringDate(date: selectedDate)
        if trainings[stringDate] != nil {
            trainInSelectedDay = trainings[stringDate]!
        }
    }
    //Change bool value of AddSetsToExercise
    func addSetsToExerciseSender(exercise:Exercise) {
        let newTraining = trainInSelectedDay
        if let index = newTraining.exercises.firstIndex(of: exercise) {
            
            newTraining.exercises[index].isSelectedToAddSet.toggle()
        }
        trainInSelectedDay = newTraining
    }
    //Create new Set
    func createNewSet(set:Sets) {
        if newSets.isEmpty {
            newSets = [set]
        } else {
            newSets.append(set)
        }
    }
    func clearArrayOfSets() {
        newSets = []
    }
    // Change or Add new Set value to the exercise
    func changeValueToExercise(exercise:Exercise,sets:Sets,weight:Double,reps:Double) {
        
        let newTraining = trainInSelectedDay
        if let exIndex = newTraining.exercises.firstIndex(of: exercise) {
            
            if let setIndex = exercise.sets.firstIndex(of:sets) {
                newTraining.exercises[exIndex].sets[setIndex].weight = weight
                newTraining.exercises[exIndex].sets[setIndex].reps = reps
                
            }
        }
        trainInSelectedDay = newTraining
        print("Done")
        
    }
    //Add new Set to the exercise
    func addNewSetToExercise(exercise:Exercise,set:Sets) {
        let newTraining = trainInSelectedDay
        
        if let exIndex = newTraining.exercises.firstIndex(of: exercise) {
            newTraining.exercises[exIndex].sets.append(set)
        }
        trainInSelectedDay = newTraining
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

