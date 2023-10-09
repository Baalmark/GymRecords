import SwiftUI
import RealmSwift
struct ContentView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var appearSheet = false
    @State private var isDataBaseSheetActive = false
    @State private var offset = CGSize.zero
    private var offsetCalendarViewY:CGFloat = 0
    private var systemColor = Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
    private var systemShadowColor = Color(UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1))
    @StateObject private var viewModel = GymViewModel()
    @State private var minimizingCalendarOffSet:CGFloat = -295
    @State private var flagCollapse:Collapse = .collapsed
    //Flags for changing calendar month
    @State private var coeffOfTrainView:CGFloat = 0
    private var previousMonth = false
    private var nextMonth = false
    @State private var collapsingViewFlag = true
    @State private var scrollToIndex:Int = 0
    @State private var mainButtonName = "Add more"
    @State private var mainButtonEditName = "Edit"
    @State private var flagAddSetMainViewAppear = false
    @State private var showSheet = false
    @State private var showAlert = false
    @State private var saveAsProgrammSheet = false
    @State private var newProgram = GymModel.Program(numberOfProgram: 1,programTitle: "", programDescription: "", colorDesign: "green", exercises: [])
    
    var body: some View {
        mainView
    }
    var mainView: some View {
        
        VStack {
            ZStack{
                VStack{
                    //Bar
                    ZStack {
                        VStack {
                            HStack {
                                MonthLabelView(month:viewModel.arrayOfMonths[1])
                                //                                    .environmentObject(viewModel)
                                    .animation(.spring(), value: viewModel.arrayOfMonths[1])
                                Spacer()
                                Button{
                                    HapticManager.instance.impact(style: .medium)
                                    viewModel.addExerciseFlag = false
                                    viewModel.editMode = false
                                    mainButtonEditName = "Edit"
                                    mainButtonName = "Add more"
                                    viewModel.changeExercisesDB = true
                                    isDataBaseSheetActive.toggle()
                                } label: {
                                    Image("weight")
                                }
                                .sheet(isPresented: $isDataBaseSheetActive) {
                                    DataBaseView()
                                }
                            }
                            .padding(.top,5)
                            .padding([.leading,.trailing], 10)
                            dayOfWeekStack
                        }
                        .frame(height:viewModel.constH(h:110),alignment:.bottom)
                        .background(.white)
                        .padding(.bottom,-10)
                        
                    }
                    
                    .zIndex(4)
                    HStack(spacing: 10) {
                        ForEach(viewModel.arrayOfMonths, id: \.self) { value in
                            CalendarView(month:value)
                        }
                    }
                    .background(.white)
                    .offset(x: offset.width, y:0)
                    .gesture(DragGesture()
                        .onChanged { value in
                            let direction = viewModel.detectDirection(value: value)
                            if direction == .left || direction == .right {}
                            offset.width = value.translation.width
                        }
                            
                        .onEnded { value in
                            let direction = viewModel.detectDirection(value: value)
                            if direction == .right, value.translation.width < -120 {
                                viewModel.updateArrayMonthsNext()
                                withAnimation() {
                                    offset.width = -405
                                }
                                offset.width = 0
                            } else if direction == .left, value.translation.width > 120{
                                viewModel.updateArrayMonthsBack()
                                withAnimation() {
                                    offset.width = 405
                                }
                                offset.width = 0
                                
                            } else {
                                withAnimation() {
                                    offset.width = 0
                                }
                            }
                            
                        })
                    
                    
                        .frame(width: viewModel.screenWidth * 3 + 30, height: viewModel.constH(h:350))
                        .offset(x:0,y:  viewModel.constH(h: minimizingCalendarOffSet / viewModel.getCoefficientOffset(row: viewModel.selectedDayRowHolder)))
                        .zIndex(3)
                        .padding(.bottom, 15)
                    
                    Spacer()
                }
                
            }
            .background(.white)
            .zIndex(2)
            .frame(height: collapsingViewFlag ? viewModel.constH(h:140) : viewModel.constH(h:415))
            
            .simultaneousGesture(DragGesture()
                .onChanged { value in
                    print("Here1")
                    let detection = viewModel.detectDirection(value: value)
                    if detection == .down || detection == .up {
                    }
                        if flagCollapse == .collapsed {
                            if minimizingCalendarOffSet + value.translation.height >= -295{ //Limit border
                                minimizingCalendarOffSet = -295 + value.translation.height
                            }
                        } else if flagCollapse == .opened {
                            if minimizingCalendarOffSet + value.translation.height <= 0 { //Limit border
                                minimizingCalendarOffSet = 0 + value.translation.height
                            }
                        }
                }
                .onEnded { value in
                    if minimizingCalendarOffSet < 0 {
                        if value.translation.height >= 85 {
                            withAnimation(.easeInOut) {
                                minimizingCalendarOffSet = 0
                                coeffOfTrainView = 0
                                collapsingViewFlag = false
                                flagCollapse = .opened
                                
                            }
                        } else {
                            withAnimation(.easeInOut) {
                                minimizingCalendarOffSet = viewModel.constH(h: -295)
                                coeffOfTrainView = viewModel.constH(h: 295)
                                collapsingViewFlag = true
                                flagCollapse = .collapsed
                            }
                        }
                    } else {
                        if value.translation.height <= -125 {
                            withAnimation(.easeInOut) {
                                minimizingCalendarOffSet = viewModel.constH(h: -295)
                                coeffOfTrainView = viewModel.constH(h: 295)
                                collapsingViewFlag = true
                                flagCollapse = .collapsed
                            }
                        }
                    }
                })
            .overlay(alignment:.center) {
                ZStack(alignment: .top){
                    //Drag gesture line view
                    dragGestureView
                        .zIndex(10)
                        .offset(x:0,y:minimizingCalendarOffSet)
                    
                    
                    ScrollView {
                        if viewModel.isAnyTrainingSelectedDay(){
                            VStack {
                                if viewModel.trainInSelectedDay.programTitle != "blank" && viewModel.trainInSelectedDay.programDescription != "blank" && viewModel.trainInSelectedDay.programTitle != viewModel.toStringDate(date: viewModel.selectedDate, history: false){
                                    ProgramItemListView(programm:$viewModel.trainInSelectedDay)
                                }
                                ForEachIndex(viewModel.trainInSelectedDay.exercises){ index,
                                    exercise in
                                    
                                    ContentViewExerciseFromTheListView(exercise: exercise).environmentObject(viewModel)
                                        .background(.white)
                                        .onTapGesture {
                                            HapticManager.instance.impact(style: .soft)
                                            viewModel.addSetsToExerciseSender(exercise:exercise)
                                            
                                            
                                        }
                                    
                                    if exercise.isSelectedToAddSet {
                                        HStack {
                                            Text(exercise.type == .cardio ? "km/h" : "weight")
                                                .frame(width: 160)
                                                .padding(.trailing,5)
                                            Text(exercise.type == .stretching || exercise.type == .cardio ? "mins" : "reps")
                                                .frame(width: 160)
                                                .padding(.leading,5)
                                        }
                                        .font(.custom("Helvetica", size: 14))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("MidGrayColor"))
                                        .frame(width: viewModel.screenWidth)
                                        AddSetsToExercise(exercise: exercise).environmentObject(viewModel)
                                            .onTapGesture {
                                                HapticManager.instance.impact(style: .soft)
                                                withAnimation(.easeInOut) {
                                                    scrollToIndex = index
                                                    viewModel.isShowedMainAddSetsView.toggle()
                                                    
                                                }
                                            }
                                        
                                    }
                                }
                                .onChange(of: viewModel.trainInSelectedDay.exercises.count) { newValue in
                                    if newValue == 0 {
                                        viewModel.trainInSelectedDay = GymModel.Program(numberOfProgram: -1,programTitle: "", programDescription: "", colorDesign: "red", exercises: [])
                                        viewModel.editMode = false
                                        viewModel.removeTrainingFromSelectedDay()
                                    }
                                }
                                
                                
                            }
                            
                            
                            .padding(.top,30)
                        } else {
                            Image("backgroundMain")
                                .resizable()
                                .offset(x:0,y: viewModel.constH(h: -minimizingCalendarOffSet / 2))
                                .padding()
                                .padding(.top,30)
                                .offset(y:collapsingViewFlag ? viewModel.constH(h:-140) : 0)
                                .scaledToFit()
                        }
                    }
                    .frame(maxWidth: viewModel.screenWidth)
                    .frame(height: collapsingViewFlag ? viewModel.constH(h:580) : viewModel.constH(h:290))
                    .background(.white)
                    .offset(x:0,y:minimizingCalendarOffSet)
                }.zIndex(10)
                    .offset(y:collapsingViewFlag ? viewModel.constH(h:510) : viewModel.constH(h:360))
                
            }
            .padding(.top,-40)
            .offset(y:viewModel.constH(h: -150))
            .onAppear {
                minimizingCalendarOffSet = viewModel.constH(h: -295)
            }
            
        }
        
        .frame(height: viewModel.screenHeight - viewModel.constH(h: -70))
        .onTapGesture {
            hideKeyboard()
        }
        .overlay {
            if !viewModel.isShowedMainAddSetsView {
                HStack {
                    if viewModel.isAnyTrainingSelectedDay(){
                        Button {
                            HapticManager.instance.impact(style: .medium)
                            showSheet.toggle()
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .padding(10)
                        }
                        .font(.custom("Helvetica", size: viewModel.constW(w:20)))
                        .background(Circle()
                            .frame(width: viewModel.constW(w:40),height: viewModel.constW(w:40))
                            .foregroundColor(Color("MidGrayColor")))
                        .blurredSheet(.init(.ultraThinMaterial), show: $showSheet) {
                            
                        } content: {
                            VStack {
                                
                                if viewModel.isAnyTrainingSelectedDay() {
                                    Button {
                                        HapticManager.instance.impact(style: .medium)
                                        withAnimation{
                                            showAlert.toggle()
                                        }
                                    } label: {
                                        Text("Delete all day")
                                            .foregroundStyle(Color("BrightRedColor"))
                                    }
                                    .padding(.bottom,10)
                                    .alert(isPresented:$showAlert, content:  {
                                        Alert(title: Text("Are you sure?"),message:Text("All exercises and data will be deleted"), primaryButton: .default(Text("Yes"),action: {
                                            withAnimation(.easeInOut) {
                                                viewModel.removeTrainingByClick(selectedDate: viewModel.selectedDate)
                                                showSheet.toggle()
                                            }
                                        }), secondaryButton: .cancel(Text("Cancel")))
                                        
                                    })
                                    
                                    
                                    Button {
                                        HapticManager.instance.impact(style: .medium)
                                        withAnimation {
                                            let stringDate = viewModel.toStringDate(date: viewModel.selectedDate, history: false)
                                            if let training = viewModel.trainings[stringDate] {
                                                
                                                var exercises = training.exercises
                                                for exercise in exercises {
                                                    exercise.sets = []
                                                }
                                                newProgram.exercises = exercises
                                                viewModel.selectedExArray = exercises
                                                newProgram.numberOfProgram = viewModel.trainings.count + 1
                                                saveAsProgrammSheet.toggle()
                                            }
                                        }
                                    } label : {
                                        Text("Save as program")
                                            .foregroundStyle(.white)
                                    }
                                    .padding(.bottom,10)
                                }
                                if !viewModel.isSelectedDayToday() {
                                    Button {
                                        HapticManager.instance.impact(style: .medium)
                                        withAnimation {
                                            viewModel.copyTraining = true
                                            let stringDate = viewModel.toStringDate(date: viewModel.selectedDate, history: false)
                                            
                                            if let training = viewModel.trainings[stringDate] {
                                                if training.programDescription == "" {
                                                    viewModel.createTraining(date: viewModel.selectedDate, exercises: training.exercises)
                                                } else {
                                                    viewModel.createTraining(date: viewModel.selectedDate, program: training)
                                                }
                                            }
                                            showSheet.toggle()
                                        }
                                    } label: {
                                        Text("Copy for today")
                                            .foregroundStyle(.white)
                                    }
                                    .padding(.bottom,10)
                                }
                                Button {
                                    HapticManager.instance.impact(style: .medium)
                                    if viewModel.isAnyTrainingSelectedDay() {
                                        withAnimation(.easeInOut) {
                                            viewModel.editMode.toggle()
                                            viewModel.editModeButtonName = viewModel.editMode ? "Finish editing" : "Edit"
                                            showSheet.toggle()
                                        }
                                    } else {
                                        appearSheet.toggle()
                                        viewModel.changeExercisesDB = false
                                    }
                                    
                                } label : {
                                    Text(viewModel.isAnyTrainingSelectedDay() ? viewModel.editModeButtonName : mainButtonName)
                                        .foregroundStyle(.white)
                                    
                                }
                            }
                            .fullScreenCover(isPresented: $saveAsProgrammSheet) {
                                CreateNewProgrammView(name: $newProgram.programTitle, description: $newProgram.programDescription, exercises: $newProgram.exercises, colorDesignStringValue: $newProgram.colorDesign,toChangeProgram: false)
                                    .onDisappear {
                                        withAnimation {
                                            showSheet.toggle()
                                        }
                                    }
                            }
                            .font(.custom("Helvetica", size: viewModel.constW(w:22)))
                            .fontWeight(.bold)
                            .presentationDetents([.fraction(0.33)])
                            .frame(maxWidth: .infinity,maxHeight: .infinity)
                            .presentationDragIndicator(.visible)
                            .background(Color("DarkbackgroundViewColor"))
                        }
                        
                        
                    }
                    if viewModel.isAnyTrainingSelectedDay() {
                        Button("Add more") {
                            HapticManager.instance.impact(style: .medium)
                            appearSheet.toggle()
                            viewModel.addExerciseFlag = true
                            viewModel.changeExercisesDB = false
                        }
                        
                        .sheet(isPresented:$appearSheet) {
                            //viewModel.dataForProgramm
                            AddProgramView()
                        }
                        .buttonStyle(GrowingButton(isDarkMode: false,width: 315,height: 45))
                        .tint(.white)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .opacity(1)
                    }
                    else {
                        Button("Create training") {
                            HapticManager.instance.impact(style: .medium)
                            appearSheet.toggle()
                            viewModel.addExerciseFlag = false
                            viewModel.changeExercisesDB = false
                            
                        }
                        .sheet(isPresented:$appearSheet) {
                            //viewModel.dataForProgramm
                            AddProgramView()
                        }
                        .buttonStyle(GrowingButton(isDarkMode: false,width: 315,height: 45))
                        .tint(.white)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .opacity(1)
                    }
                    
                }
                .zIndex(3)
                .padding(.bottom,20)
                .padding(.top,10)
                .padding([.leading,.trailing],30)
                .background(.white)
                .offset(y:viewModel.constH(h:370))
                
            }
            if viewModel.isShowedMainAddSetsView {
                withAnimation(.easeOut) {
                    AddNewSetsMainView(scrollToIndex: scrollToIndex).environmentObject(viewModel)
                        .background(viewModel.blurOrBlackBackground ? .ultraThinMaterial : .ultraThick)
                        .transition(.move(edge: .bottom))
                        .onDisappear {
                            scrollToIndex = 0
                            
                        }
                    
                }
            }
            
        }
        .environmentObject(viewModel)
        
        
    }
    var dayOfWeekStack: some View
    {
        HStack(spacing: 1)
        {
            
            Text("Mon").dayOfWeek()
            Text("Tue").dayOfWeek()
            Text("Wed").dayOfWeek()
            Text("Thu").dayOfWeek()
            Text("Fri").dayOfWeek()
            Text("Sat").dayOfWeek()
            Text("Sun").dayOfWeek()
        }
        .fontWeight(.bold)
        .foregroundColor(Color("MidGrayColor"))
    }
    
    var dragGestureView: some View
    {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: viewModel.screenWidth,height: 20)
                .shadow(color: Color("LightGrayColor"), radius: 3,x:0,y:6)
                .foregroundColor(.white)
                .zIndex(2)
            RoundedRectangle(cornerRadius: 50)
                .frame(width: 45,height: 4)
                .foregroundColor(Color("LightGrayColor"))
                .zIndex(2)
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        let _ = Migrator()
        ContentView().environmentObject(GymViewModel())
        
    }
}



