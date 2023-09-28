

import SwiftUI
import RealmSwift

class GymViewModel: ObservableObject {
    
    lazy var realm = try! Realm()
    private(set) var gymModel = GymModel()
    
    @ObservedResults(ProgramObject.self) var programObjects
    @ObservedResults(ExerciseObject.self) var exerciseObjects
    @ObservedResults(SetsObject.self) var setsObjects
    @ObservedResults(TrainingInfoObject.self) var trainingInfoObjects
    @ObservedResults(GymModelObject.self) var GymModelObjects
    
    
    let standartScreenWidth:CGFloat = 393.0
    let standartScreenHeight:CGFloat = 852.0
    @Published var isSelectedSomeExercise:Bool = false
    @Published var changeExercisesDB:Bool = false
    @Published var isDarkMode:Bool = false
    @Published var selectedExArray:[Exercise] = []
    @Published var databaseInfoTitle:[(String,Int)]
    @Published var backButtonLabel:String = ""
    @Published var programList:[GymModel.Program] = []
    
    //Edit or Remove View appears and dissapears by these variables
    @Published var isShowedEditOrRemoveView:Bool = false
    @Published var showedEdirOrRemoveProgram:GymModel.Program
    
    //View List Specifi Exercise appears and dissapears by these variables
    @Published var isShowedViewListSpecificExercise:Bool = false
    @Published var showedViewListSpecificExercise:GymModel.TypeOfExercise = .arms
    @Published var isShowedCreateNewExerciseList:Bool = false
    @Published var isShowedCreateExView:Bool = false
    //Passing Date for new Programm
    @Published var dateForProgramm:Date
    
    //Finder any Exercises
    @Published var searchWord:String = ""
    @Published var arrayOfFoundExercise:[Exercise] = []
    @Published var isSearching: Bool = true
    
    
    //Date holder
    @Published var date:Date
    @Published var arrayOfMonths:[Date] = []
    @Published var selectedDate:Date = Date() // Selected Date for new training day
    @Published var selectedDayForChecking:Int = 0
    @Published var selectedDayRowHolder = 0
    
    //All property to creating a training day
    @Published var trainings:[String:GymModel.Program]
    @Published var selectedExerciseSetsHistory:[Date:[Sets]] = [:]
    @Published var selectedExerciseSetsHistoryArray:[Dictionary<Date, [Sets]>.Element] = []
    @Published var monthsForSectionsInHistory:[SetInfo] = []
    @Published var selectedProgramForNewTrainingDay:GymModel.Program? = nil
    @Published var trainInSelectedDay:GymModel.Program
    @Published var selectedCounterLabel:[Int] = []
    @Published var arrayOfSetsHistory:[SetInfo] = []
    @Published var displayedMonths:[String] = []
    
    //Computed or Store value of Delete / Create / Change a set for the exercise
    @Published var didTapToAddSet:Bool = false
    @Published var didTapToAddAnotherOneSet = false
    @Published var setsBackUp:[Sets] = []
    @Published var newSets:[Sets] = []
    @Published var crntExrcsFrEditSets:Exercise
    @Published var blurOrBlackBackground:Bool = true
    @Published var lastChangedExercise:Exercise? = nil
    
    //Show view with sets
    @Published var isShowedMainAddSetsView = false
    //Edit program on the Main Content View
    @Published var editMode = false
    @Published var editModeButtonName = "Edit program"
    @Published var addExerciseFlag = false
    
    
    //Statistic view and other vars for Graphs
    @Published var willAppearStatisticView = false
    @Published var selectedExerciseForStatisticView:Exercise? = nil
    @Published var selectedPeriod:Int = 7
    @Published var maxSummaryReps:Double? = 0
    @Published var maxSummaryWeight:Double? = 0
    
    //Design Vars
    var viewCornerRadiusSimple:CGFloat = 10
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    var paddingSafeArea = 20
    var colors = GymModel.colors
    var exerciseList:[GymModel.TypeOfExercise] = GymModel.TypeOfExercise.allExercises
    var imagesArray:[UIImage] = []
    var stringExerciseList:[String] = []
    var arrayExercises:[Exercise] = []
    
    init() {
        
        
        @ObservedResults(GymModelObject.self) var GymModelObjects
        self.selectedExArray = []
        if GymModelObjects.isEmpty {
            DataLoader().createGymModelObject()
            DataLoader().saveCreatedExerciseByRealm()
            self.programList = gymModel.programs
            self.trainings = gymModel.trainingDictionary
            self.showedEdirOrRemoveProgram = gymModel.programs[0]
            self.arrayExercises = GymModel.arrayOfAllCreatedExercises
            self.databaseInfoTitle = [("WorkOut",DataLoader().returnCountOfTrainings()),("Programs",DataLoader().returnCountOfPrograms()),("Exercises",DataLoader().returnCountOfExercises())]
            
        } else {
            let loadedPrograms = DataLoader().loadPrograms()
            let loadedExercises = DataLoader().loadExercises()
            let loadedTrainings = DataLoader().loadTrainingDictionary()
            if loadedPrograms.isEmpty {
                showedEdirOrRemoveProgram = gymModel.programs[0]
            } else {
                showedEdirOrRemoveProgram = loadedPrograms[0]
            }
            self.trainings = loadedTrainings
            self.gymModel = GymModel(programs:loadedPrograms,exercises: loadedExercises)
            self.arrayExercises = loadedExercises
            self.programList = loadedPrograms
            self.databaseInfoTitle = [("WorkOut",DataLoader().returnCountOfTrainings()),("Programs",DataLoader().returnCountOfPrograms()),("Exercises",DataLoader().returnCountOfExercises())]
        }
        
        //Date holder
        
        self.date = Date()
        self.dateForProgramm = Date.now
        self.arrayOfMonths = [CalendarModel().minusMonth(Date()),Date(),CalendarModel().plusMonth(Date())]
        
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date())
        selectedDayForChecking = components.day!
        trainInSelectedDay = GymModel.Program(numberOfProgram:0,programTitle: "blank", programDescription: "blank", colorDesign: "red", exercises: [])
        self.crntExrcsFrEditSets = Exercise(type: .arms, name: "blank", doubleWeight: false, selfWeight: false, isSelected: false, sets: [], isSelectedToAddSet: false)
    }
    
    func forTrailingZero(_ temp: Double) -> String {
        var tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    public func appendImagesToArray(image img:UIImage) {
        imagesArray.append(img)
    }
    //MARK: List of exercise types
    func getListOfExercises(){
        for element in exerciseList {
            stringExerciseList.append(element.rawValue)
        }
    }
    
    //MARK: Compure selected Counter Label
    func computeSelectedCounderLabel() -> Array<Int> {
        var array:[Int] = []
        for element in exerciseList {
            let result = findNumberOfSelectedExerciseByTypeVM(
                type: element, array: arrayExercises)
            array.append(result)
            
        }
        return array
    }
    
    //MARK: Add months in array
    
    func addMonthIntoArrayOfMonths(month:String) {
        displayedMonths.append(month)
    }
    //MARK: Exercise selection
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
    
    //MARK: Couple exercises unselection
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
    //MARK: Exercise unselection
    func unselectingExercise(exercise:Exercise,isSelected:Bool) {
        let newItem = Exercise(type: exercise.type, name: exercise.name, doubleWeight: exercise.doubleWeight, selfWeight: exercise.selfWeight, isSelected: isSelected, sets: [], isSelectedToAddSet: false)
        
        selectedExArray = selectedExArray.filter({$0.name != exercise.name})
        
        for (i,element) in arrayExercises.enumerated() {
            if element.isSelected != newItem.isSelected, element.name == newItem.name {
                arrayExercises[i].isSelected = newItem.isSelected
            }
        }
    }
    
    //MARK: Find exercise from array by name
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
    //MARK: Constraining
    func constH(h:CGFloat) -> CGFloat {
        return h * (screenHeight / standartScreenHeight)
    }
    func constW(w:CGFloat) -> CGFloat {
        return w * (screenWidth / standartScreenWidth)
    }
    //MARK: Find a number of exercise same type.
    func findNumberOfExerciseOneType(type:GymModel.TypeOfExercise,array:Array<Exercise>) -> Int {
        return gymModel.findNumberOfExerciseOneType(type: type, array: array)
    }
    
    //MARK: Find a number of selected Exercise by type of exercise (VM - ViewModel )
    func findNumberOfSelectedExerciseByTypeVM(type:GymModel.TypeOfExercise,array:Array<Exercise>) -> Int {
        return gymModel.findNumberOfSelectedExerciseByType(type: type, array: array)
    }
    
    
    //MARK: Remove some exercise by user's choice
    func removeSomeExercise(exercise:Exercise) {
        let newArray = gymModel.removeSomeExerciseFromArray(exercise: exercise, array: arrayExercises)
        
        arrayExercises = newArray
        //Reload info for DataBaseTitle Exercise Counter
        
        //Reload DB Info
        databaseInfoTitle = gymModel.reloadDataBaseInfo(trainDictionary: trainings, progArray: programList, arrayExercises: arrayExercises)
    }
    
    //MARK: Change settings of exerise by toggle.
    func toggleBodyAndDoubleWeight(exercise:Exercise,bodyWeight:Bool,doubleWeight:Bool) {
        let newExercise = gymModel.modelToggleBodyAndDoubleWeight(exercise:exercise,bodyWeight:bodyWeight,doubleWeight:doubleWeight)
        let newArray = gymModel.replaceExerciseInArray(exercise: newExercise, array: arrayExercises)
        arrayExercises = newArray
    }
    //MARK: Create a new Exercise
    func createNewExercise(exercise:Exercise) {
        let newArray = gymModel.createNewExercise(exercise: exercise, array: arrayExercises)
        arrayExercises = newArray
        
        
        saveExerciseByRealmDB(exercise: exercise)
        //Reload DB Info
        databaseInfoTitle = gymModel.reloadDataBaseInfo(trainDictionary: trainings, progArray: programList, arrayExercises: arrayExercises)
    }
    
    //MARK:  Create a new program
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
        saveProgramIntoRealmDB(newProgram: program)
        
    }
    //MARK: Remove some program
    
    func removeProgram(program:GymModel.Program) {
        
        for (index,element) in programList.enumerated() {
            if element.programTitle == program.programTitle {
                programList.remove(at: index)
                gymModel.removeProgram(index)
            }
        }
        
    }
    
    //MARK: Select programm for new training Day
    func selectingProgrammForNewTrainingDay(program:GymModel.Program) {
        selectedProgramForNewTrainingDay = program
    }
    
    //MARK: Find any exercises by search
    func findAnyExerciseByLetters(letters:String,array:[Exercise]) -> Array<Exercise>{
        return gymModel.finderByTextField(letters: letters, array: array)
    }
    //MARK: Behavior for the Calendar View
    
    
    //MARK: Enum of directions
    enum SwipeHVDirection: String {
        case left, right, up, down, none
    }
    //MARK: Detecting drag gesture directions
    
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
    //MARK: Updating array of months
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
    //MARK:  Selecting new day for new training day
    func selectDayForTraining(day:Int) {
        //Update month
        updateMonth()
        selectedDate = CalendarModel().selectDay(date, day: day)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: selectedDate)
        selectedDayForChecking = components.day!
        
    }
    //MARK:  Update month of current date
    
    func updateMonth() {
        date = arrayOfMonths[1]
    }
    
    //MARK:  "Is the correct day selected?" function
    func isSelectedDay(day:Int,date:Date) -> Bool {
        return selectedDayForChecking == day  && date == arrayOfMonths[1]
    }
    
    //MARK:  Create new training day
    
    func createTraining(date:Date,exercises:[Exercise]){
        
        if addExerciseFlag {
            
            let stringDate = toStringDate(date: date, history: false)
            let training = realm.objects(TrainingInfoObject.self).where { $0.date == stringDate}.first!
            var namesOfExercises:[String] = []
            
            for exercise in exercises {
                namesOfExercises.append(exercise.name)
                trainInSelectedDay.exercises.append(exercise)
                trainings[stringDate]?.exercises.append(exercise)
            }
            for elem in namesOfExercises {
                let exercise = realm.objects(ExerciseObject.self).where { $0.name == elem }
                try! realm.write {
                    training.program?.exercises.append(objectsIn: exercise)
                }
            }
            
        } else {
            let stringDate = toStringDate(date: date, history: false)
            let newProgram = GymModel.Program(numberOfProgram:trainings.count + 1,programTitle: stringDate, programDescription: "", colorDesign: "green", exercises: exercises)
            trainings[stringDate] = newProgram
            trainInSelectedDay = newProgram
            saveTrainingIntoRealmDB(date: stringDate, program: newProgram)
            databaseInfoTitle =  gymModel.reloadDataBaseInfo(trainDictionary: trainings, progArray: programList, arrayExercises: arrayExercises)
        }
    }
    //MARK: Create training function
    func createTraining(date:Date,program:GymModel.Program)  {
        
        let stringDate = toStringDate(date: date, history: false)
        if addExerciseFlag {


            let training = realm.objects(TrainingInfoObject.self).where { $0.date == stringDate}.first!
            var namesOfExercises:[String] = []
            
            for exercise in program.exercises {
                namesOfExercises.append(exercise.name)
                trainInSelectedDay.exercises.append(exercise)
                trainings[stringDate]?.exercises.append(exercise)
            }
            for elem in namesOfExercises {
                let exercise = realm.objects(ExerciseObject.self).where { $0.name == elem }
                try! realm.write {
                    training.program?.exercises.append(objectsIn: exercise)
                }
            }
            
        } else {
            let newProgram = GymModel.Program(numberOfProgram: program.numberOfProgram,programTitle: program.programTitle,
                                              programDescription: program.programDescription, colorDesign: program.colorDesign,
                                              exercises: program.exercises)
            trainings[stringDate] = newProgram
            trainInSelectedDay = newProgram
            saveTrainingIntoRealmDB(date: stringDate, program: program)
            
            databaseInfoTitle =  gymModel.reloadDataBaseInfo(trainDictionary: trainings, progArray: programList, arrayExercises: arrayExercises)
        }
        
    }
    
    //MARK: Creating String of Date from Date
    func toStringDate(date:Date,history:Bool) -> String {
        let dateFormater = DateFormatter()
        if history {
            dateFormater.dateFormat = "d MMM"
            return dateFormater.string(from: date)
        } else {
            dateFormater.dateFormat = "y/M/d"
            return dateFormater.string(from: date)
        }
    }
    
    //MARK: Creating date from string
    
    func toDateFromStringDate(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: date) {
            return date
        }
        return nil
    }
    
    //MARK: Checking the row for the selected day
    func checkTheRowForTheSelectedDay(correctDay:Int, month:Date) -> Bool{
        let components = selectedDate.get(.day, .month, .year)
        if components.day == correctDay && Calendar.current.isDate(selectedDate, equalTo: month, toGranularity: .month) {
            return true
        }
        return false
    }
    //MARK:  The function that calculates with what coefficient to shift the calendar view when you use the drag gesture
    
    func getCoefficientOffset(row:Int) -> CGFloat {
        //
        if let offset = CalendarMinimizingPosition(id: row) {
            return constH(h: offset.rawValue)
        }
        return constH(h: CalendarMinimizingPosition.zero.rawValue)
    }
    
    //MARK: Сheck for training availability on the selected day
    func isAnyTrainingSelectedDay() -> Bool {
        let stringDate = toStringDate(date: selectedDate, history: false)
        
        return trainings[stringDate] != nil
        
    }
    
    //MARK: ?? needs to figure it out
    func isAnyTrainingAnyDayDisplayMark(day:Int,month:Int) -> Bool {
        
        
        //D
        //        for date in trainings.keys {
        //
        //            if let date = toDateFromStringDate(date: date) {
        //                let components = date.get(.day, .month, .year)
        //            }
        //
        //        }
        return true
    }
    
    func removeTrainingFromSelectedDay() {
        let stringDate = toStringDate(date: selectedDate, history: false)
        
        trainings[stringDate] = nil
    }
    
    //MARK: Selecting the day with a training
    func selectingTheDayWithTraining() {
        let stringDate = toStringDate(date: selectedDate, history: false)
        if trainings[stringDate] != nil {
            trainInSelectedDay = trainings[stringDate]!
        }
    }
    //MARK: Change bool value of AddSetsToExercise
    func addSetsToExerciseSender(exercise:Exercise) {
        let newTraining = trainInSelectedDay
        if let index = newTraining.exercises.firstIndex(of: exercise) {
            newTraining.exercises[index].isSelectedToAddSet.toggle()
        }
        trainInSelectedDay = newTraining
    }
    //MARK: Create new Set
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
    //MARK:  Change or Add new Set value to the exercise
    func changeValueToExercise(exercise:Exercise,sets:Sets,weight:Double,reps:Double) {
        
        let newTraining = trainInSelectedDay
        if let exIndex = newTraining.exercises.firstIndex(of: exercise) {
            
            if let setIndex = exercise.sets.firstIndex(of:sets) {
                newTraining.exercises[exIndex].sets[setIndex].weight = weight
                newTraining.exercises[exIndex].sets[setIndex].reps = reps
                
            }
        }
        trainInSelectedDay = newTraining
    }
    //MARK: Add new Set to the exercise
    func addNewSetsToExercise(exercise:Exercise,sets:[Sets]) {
        let newTraining = trainInSelectedDay
        
        if let exIndex = newTraining.exercises.firstIndex(of: exercise) {
            newTraining.exercises[exIndex].sets = sets
        }
        trainInSelectedDay = newTraining
    }
    
    //MARK: Creator a set
    func createSet(exercise:Exercise) -> Exercise{
        let newEx = exercise
        if !exercise.sets.isEmpty {
            let newElement = Sets(number: exercise.sets.count + 1,date: selectedDate, weight: exercise.sets.last!.weight, reps: exercise.sets.last!.reps, doubleWeight: exercise.doubleWeight, selfWeight: exercise.selfWeight)
            newEx.sets.append(newElement)
        } else {
            let newElement = Sets(number: exercise.sets.count + 1, date: selectedDate, weight: 0, reps: 0, doubleWeight: exercise.doubleWeight, selfWeight: exercise.selfWeight)
            newEx.sets.append(newElement)
        }
        
        return newEx
    }
    
    //MARK: Remove set from the list of Sets
    func removelastSet(exercise:Exercise){
        exercise.sets.removeLast()
        lastChangedExercise = exercise
    }
    
    //MARK: Save certain set in the exercise
    func saveSetInEx(set:Sets,exercise:Exercise) -> Exercise{
        let nEx = exercise
        nEx.sets[set.number-1] = set
        
        return nEx
    }
    //        saveEditedExercise(exercise: exercise)
    
    
    //MARK: Save exercise with edited sets
    func saveEditedExercise(exercise:Exercise,newSets:[Sets]) {
        let newTraining = trainInSelectedDay
        for var ex in newTraining.exercises {
            if ex.name == exercise.name  {
                ex = exercise
            }
        }
        trainInSelectedDay = newTraining
        
        //Realm Changing data
        let stringDate = toStringDate(date: selectedDate, history: false)
        let trainings = realm.objects(TrainingInfoObject.self)
        
        
        for train in trainings {
            if train.date == stringDate {
                let trainInfo = realm.objects(TrainingInfoObject.self).where { $0.date == train.date }.first!
                if let program = trainInfo.program {
                    for ex in program.exercises {
                        if ex.name == exercise.name {
                            for exSet in exercise.sets {
                                if toStringDate(date:exSet.date, history: false) == train.date {
                                    let setObject = SetsObject()
                                    setObject.date = exSet.date
                                    setObject.number = exSet.number
                                    setObject.doubleWeight = exSet.doubleWeight
                                    setObject.selfWeight = exSet.selfWeight
                                    setObject.reps = exSet.reps
                                    setObject.weight = exSet.weight
                                    
                                    try! realm.write {
                                        ex.sets.append(setObject)
                                    }
                                }
                                
                            }
                        }
                    }
                    //                    createRealmFormatOfProgramObject(program, trainInSelectedDay)
                    //
                    //                    train.program = program
                }
            }
        }
    }
    //MARK: Comparison of the name in the finished program with the list of names of all exercises
    func comprasionNameExerciseWithListAllExercises(name:String,exercises:[Exercise]) -> Bool {
        if addExerciseFlag == false { return false }
        for elem in exercises {
            if name == elem.name { return true }
        }
        return false
    }
    //MARK: Same date check
    func sameDateCheck(date1:Date,date2:Date) -> Bool {
        let date1String = toStringDate(date: date1, history: false)
        let date2String = toStringDate(date: date2, history: false)
//        let realmSet2 = realm.objects(SetsObject.self).where { $0.date == date2}
        return date1String == date2String
    }
    //MARK: Get number of view in the addSetMainView for AddSetButton
    func getNumberAddSetButton(sets:[Sets]) -> Int {
        var tempResult = 0
        for element in sets {
            if sameDateCheck(date1: selectedDate, date2: element.date) {
                tempResult += 1
            }
        }
        return tempResult + 1
    }
    
    //MARK: Unselecting exercise
    func unSelectingEx(array:[Exercise]) {
        for element in array {
            element.isSelected = false
        }
    }
    
    //MARK: Remove exercise from list of trainins by selecting day
    func removeExerciseFromListOfTrainingInSelectedDay(exercise:Exercise,selectedDate:Date) {
        
        let stringDate = toStringDate(date: selectedDate, history: false)
        if var training = trainings[stringDate] {
            if let indexOfTraining = training.exercises.firstIndex(of: exercise) {
                training.exercises.remove(at: indexOfTraining)
            }
            //Realm Changing data
            let trainings = realm.objects(TrainingInfoObject.self)
            
            try! realm.write {
                for train in trainings {
                    if train.date == stringDate {
                        let newProgram = ProgramObject()
                        createRealmFormatOfProgramObject(newProgram, trainInSelectedDay)
                        train.program = newProgram
                    }
                }
            }
            if training.exercises.isEmpty {
                removeTrainingFromRealmDB(date: stringDate, program: training)
                trainInSelectedDay = GymModel.Program(numberOfProgram:-1,programTitle: "", programDescription: "", colorDesign: "red", exercises: [])
            }
        }
        if let indexOfExercise = trainInSelectedDay.exercises.firstIndex(of: exercise) {
            trainInSelectedDay.exercises.remove(at: indexOfExercise)
        }
    }
    //MARK: Remove whole training by one click
    func removeTrainingByClick(selectedDate:Date) {
        let stringDate = toStringDate(date: selectedDate, history: false)
        if let training = trainings[stringDate] {
            removeTrainingFromRealmDB(date: stringDate, program: training)
            trainInSelectedDay = GymModel.Program(numberOfProgram:-1,programTitle: "", programDescription: "", colorDesign: "red", exercises: [])
        }
    }
    //MARK: Change program in realm DB
    func changeProgramRealm(program:GymModel.Program) {
        DataLoader().changeProgramRealm(program: program)
        
    }
    //MARK: Get number of Program
    func getterNumberOfProgram() -> Int{
        return realm.objects(ProgramObject.self).count
    }
    
    //MARK: Saving all data by Realm
    
    //MARK: Save Program into realm Data Base
    fileprivate func createRealmFormatOfProgramObject(_ programObject: ProgramObject, _ newProgram: GymModel.Program) {
        DataLoader().createRealmFormatOfProgramObject(programObject, newProgram)
    }
    //MARK: Save Program into Realm DB
    func saveProgramIntoRealmDB(newProgram:GymModel.Program) {
        DataLoader().saveProgramIntoRealmDB(newProgram: newProgram)
    }
    //MARK: Create sets for Realm Exercise
    fileprivate func setCreatorForRealm(_ element: Exercise, _ exerciseObject: ExerciseObject) {
        DataLoader().setCreatorForRealm(element, exerciseObject)
    }
    //MARK: Save trainings into Realm Data Base
    func saveTrainingIntoRealmDB(date:String,exercises:[Exercise]) {
        DataLoader().saveTrainingIntoRealmDB(date: date, exercises: exercises)
    }
    
    //MARK: Reformatting to Realm Format Exercise
    fileprivate func reformattingExerciseToRealmFormat(element: Exercise) -> ExerciseObject{
        return DataLoader().reformattingExerciseToRealmFormat(element: element)
    }
    //MARK: Save trainings into Realm DataBase
    func saveTrainingIntoRealmDB(date:String,program:GymModel.Program) {
        DataLoader().saveTrainingIntoRealmDB(date: date, program: program)
    }
    //MARK: Remove trainings into Realm DataBase
    func removeTrainingFromRealmDB(date:String,program:GymModel.Program) {
        
        DataLoader().removeTrainingFromRealmDB(date: date, program: program)
        
    }
    //MARK: Saving new exercise into Realm
    func saveExerciseByRealmDB(exercise:Exercise) {
        DataLoader().saveExerciseByRealm(exercise: exercise)
    }
    
    //MARK: Saving created exercise
    func saveExerciseByRealm(exercise:Exercise) {
        
        DataLoader().saveCreatedExerciseByRealm()
    }
    
    //MARK: Graphs Data Functions
    
    //MARK: Get data of weight for weight graph
    
    func weightGraphDataGetter(exercise:Exercise) -> [WeightData] {
        var result:[WeightData] = []
        for nSet in exercise.sets {
            let newObject = WeightData(day: nSet.date,weight: nSet.weight)
            result.append(newObject)
        }
        return result
    }
    //MARK: Get data of reps for reps graph
    
    func repsGraphDataGetter(exercise:Exercise) -> [RepsData] {
        var result:[RepsData] = []
        for nSet in exercise.sets {
            let newObject = RepsData(day: nSet.date,reps: nSet.reps)
            result.append(newObject)
        }
        return result
    }
    func selectPeriodForCharts(period:String) {
        
        selectedPeriod = returnInDays(period: period)

    }
    
    func returnInDays(period:String) -> Int {
        switch period {
        case "Week": return 7
        case "Month": return 30
        case "Year": return 365
        default: return 7
        }
    }
    
    func returnStartAndEndOfPeriodForChart(startPoint:Date,endPoint:Date) -> (String,String){
        let dateFormatter = DateFormatter()
        if selectedPeriod == 7 {
            dateFormatter.dateFormat = "MMM d"
            let start = dateFormatter.string(from: startPoint)
            let end = dateFormatter.string(from: endPoint)
            return (start,end)
        } else if selectedPeriod == 30 {
            dateFormatter.dateFormat = "MMM"
            let start = dateFormatter.string(from: startPoint)
            let end = dateFormatter.string(from: endPoint)
            return (start,end)
        } else {
            dateFormatter.dateFormat = "yyyy"
            let start = dateFormatter.string(from: startPoint)
            let end = dateFormatter.string(from: endPoint)
            return (start,end)

        }
    }
    
    func returnHistory(exer:Exercise) {
        
        var sets:[Sets] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for dat in trainings {


            let date = dateFormatter.date(from: dat.key)
            if let date = date {
//                dateFormatter.dateFormat = "dd-MMMM-yyyy"
                if let exerciseObject = dat.value.exercises.first(where: {$0.name == exer.name}) {
                    sets = exerciseObject.sets
                    selectedExerciseSetsHistory[date] = sets.filter( { toStringDate(date:$0.date, history: false) == toStringDate(date:date, history: false) })

                }
            }
        }

        selectedExerciseSetsHistoryArray = Array(selectedExerciseSetsHistory).sorted(by: { $0.0.compare($1.0) == .orderedDescending })

        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MMMM"
        var tempMonth = "January"
        for object in selectedExerciseSetsHistoryArray {
            let newMonth = newDateFormatter.string(from: object.key)
            
            if !displayedMonths.contains(newMonth) {
                addMonthIntoArrayOfMonths(month: newMonth)
            }
            if tempMonth != newMonth {
                tempMonth = newMonth
            }
            
            let tupleOfSets = returnTupleOfSet(sets: object.value)
            let setHistoryObject = SetInfo(month: tempMonth, arrayOfSets: [SetInfo.oneSet(date: toStringDate(date:object.key, history: true), approach: tupleOfSets)])
            monthsForSectionsInHistory.append(setHistoryObject)
        }

        
    }
    //MARK: [(Weight,Reps)]
    func returnTupleOfSet(sets:[Sets]) -> [SetInfo.oneSet.repsAndWeight]
    {
        var result:[SetInfo.oneSet.repsAndWeight] = []
        for nSet in sets {
            
            let temp = SetInfo.oneSet.repsAndWeight(rep: nSet.reps, weight: nSet.weight)
            result.append(temp)
        }
        
        return result
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
//MARK:  Hide keyboard by touches outside
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
//MARK: Change color of TextField placeholder
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

//MARK: ForEach index Extension
struct ForEachIndex<ItemType, ContentView: View>: View {
    let data: [ItemType]
    let content: (Int, ItemType) -> ContentView
    
    init(_ data: [ItemType], @ViewBuilder content: @escaping (Int, ItemType) -> ContentView) {
        self.data = data
        self.content = content
    }
    
    var body: some View {
        ForEach(Array(zip(data.indices, data)), id: \.0) { idx, item in
            content(idx, item)
        }
    }
}

public extension EnvironmentValues {
    var isPreview: Bool {
#if DEBUG
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
#else
        return false
#endif
    }
}

//MARK:  Convert Results into List
extension Results {
    var list: RealmSwift.List<Element> {
        reduce(.init()) { list, element in
            list.append(element)
            return list
        }
    }
}
