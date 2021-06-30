//
//  ContentModel.swift
//  LearningSwift
//
//  Created by DHV on 14/06/2021.
//

import Foundation
import Firebase
import FirebaseAuth

class ContentModel: ObservableObject {
    
    //Authentication
    @Published var loggedIn = false
    
    //reference to Cloud Firestore database
    let db = Firestore.firestore()
    
    //list of module
    @Published var modules = [Module]()
    
    //curent model
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    //current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
        //current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    //Curent lesson explanation
    @Published var codeDescription = NSAttributedString()
    
    //current lesson/ question index
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    var styleData: Data?
    
    
   // var styleData: Data?
    
    init() {
        

        //Parse remote json file and parse the data
        //getRemoteData()
        
    }
    
    func checkLogin() {
        
        //check loggin status
        loggedIn = Auth.auth().currentUser != nil ? true : false
        if UserService.shared.user.name == "" {
            getUserData()
        }
    }
    
    func saveData(writeToDatabase: Bool = false) {
        
        if let loggedInUser = Auth.auth().currentUser {
            
            //save the progress locally
            let user = UserService.shared.user
            
            user.lastModule = currentModuleIndex
            user.lastLesson = currentLessonIndex
            user.lastQuestion = currentQuestionIndex
            
            if writeToDatabase == true {
                
                //save to database
                let db = Firestore.firestore()
                let ref = db.collection("user").document(loggedInUser.uid)
                
                ref.setData(["lastModule":user.lastModule ?? NSNull(),
                             "lastLesson":user.lastLesson ?? NSNull(),
                             "lastQuestion":user.lastQuestion ?? NSNull()], merge: true)
                
            }
            
        }

    }
    
    
    func getUserData() {
        
        // Check that there's a logged in user
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        // Get the meta data for that user
        let db = Firestore.firestore()
        let ref = db.collection("user").document(Auth.auth().currentUser!.uid)
        ref.getDocument { snapshot, error in
            
            // Check there's no errors
            guard error == nil, snapshot != nil else {
                return
            }
            
            // Parse the data out and set the user meta data
            let data = snapshot!.data()
            let user = UserService.shared.user
            user.name = data?["name"] as? String ?? ""
            user.lastModule = data?["lastModule"] as? Int
            user.lastLesson = data?["lastLesson"] as? Int
            user.lastQuestion = data?["lastQuestion"] as? Int
        }
    }
    
    func getDatabaseModules() {
        //Parse local styles html
        getLocalStyles()
        
        let collection = db.collection("modules")
        
        //get document
        collection.getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                //create an array for the modules
                var modules = [Module]()
                
                //loop thruoght the document returned
                for doc in snapshot!.documents {
                    //create a new module instance
                    var m = Module()
                    
                    //parse the values from doument in to the module instance
                    m.id = doc["id"] as? String ?? UUID().uuidString
                    m.category = doc["category"] as? String ?? ""
                    
                    //parse the lesson content
                    let contentMap = doc["content"] as! [String:Any]
                    
                    m.content.id = contentMap["id"] as? String ?? ""
                    m.content.description = contentMap["description"] as? String ?? ""
                    m.content.image = contentMap["image"] as? String ?? ""
                    m.content.time = contentMap["time"] as? String ?? ""
                    
                    //parse the test content
                    let testMap = doc["test"] as! [String:Any]
                    
                    m.test.id = doc["id"] as? String ?? ""
                    m.test.description = testMap["description"] as? String ?? ""
                    m.test.image = testMap["image"] as? String ?? ""
                    m.test.time = testMap["time"] as? String ?? ""
                    
                    //add this module to array
                    modules.append(m)
                }
                DispatchQueue.main.async {
                    self.modules = modules
                }
            }
        }
        
    }
    
    func getLessons(module: Module, completion: @escaping () -> Void) {
        
        //get path
        let collection = db.collection("modules").document(module.id).collection("lessons")
        
        //get document
        collection.getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                //array lessons
                var lessons = [Lesson]()
                
                //loop the document and build array of lesson
                for doc in snapshot!.documents {
                   //new lesson
                    var l = Lesson()
                    
                    l.id = doc["id"] as? String ?? UUID().uuidString
                    l.title = doc["title"] as? String ?? ""
                    l.video = doc["video"] as? String ?? ""
                    l.duration = doc["duration"] as? String ?? ""
                    l.explanation = doc["explanation"] as? String ?? ""
                    
                    //append this lesson to array
                    lessons.append(l)
                    
                }
                // setting the lessons to the modules
                // loop through published modules array and find the one that matchs the id of the copy that got passed in
                
                for (index , m) in self.modules.enumerated() {
                    
                    if m.id == module.id {
                        self.modules[index].content.lessons = lessons
                        
                        //call the completion clouse
                        completion()
                    }
                }
                
            }
        }
        
    }
    
    func getQuestions(module: Module , completion: @escaping () -> Void) {
        
        
        //get path
        let collection = db.collection("modules").document(module.id).collection("questions")
        
        //get document
        collection.getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                //array lessons
                var questions = [Question]()
                
                //loop the document and build array of lesson
                for doc in snapshot!.documents {
                   //new lesson
                    var q = Question()
                    
                    q.id = doc["id"] as? String ?? UUID().uuidString
                    q.content = doc["content"] as? String ?? ""
                    q.correctIndex = doc["correctIndex"] as? Int ?? 0
                    q.answers = doc["answers"] as? [String] ?? [String]()
                    
                    //append this lesson to array
                    questions.append(q)
                    
                }
                // setting the lessons to the modules
                // loop through published modules array and find the one that matchs the id of the copy that got passed in
                
                for (index , m) in self.modules.enumerated() {
                    
                    if m.id == module.id {
                        self.modules[index].test.questions = questions
                        
                        //call the completion clouse
                        completion()
                    }
                }
                
            }
        }
        
    }
    
    func getLocalStyles() {
        
//        //get a url to json file
//        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
//
//        do {
//            //read the file into a data object
//            let jsonData = try Data(contentsOf: jsonUrl!)
//
//            let jsonDecoder = JSONDecoder()
//            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
//
//            //assign parsed modules to modules property
//            self.modules = modules
//
//        }catch {
//            //print the error
//            print(error)
//        }
        
        //parse th style data
        
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            let styleData = try Data(contentsOf: styleUrl!)
            self.styleData = styleData
        } catch  {
            print(error)
        }
        
    }
    
    func getRemoteData() {
        
        //String path
        let urlString = "https://dhv10.github.io/learningSwiftUI-data/data2.json"
        
        //create url object
        let url = URL(string: urlString)
        
        guard url != nil else {
            //cannot create url
            return
        }
        //create a URLRequest object
        let request = URLRequest(url: url!)
        
        //get the season and kick off the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            //check if has a error
            guard error == nil else {
                //the has a error
                return
            }
            
            do{
                //create json decoder
                let decoder = JSONDecoder()
                
                //decode
                let modules = try decoder.decode([Module].self, from: data!)
                
                DispatchQueue.main.async {
                    //append parsed modules into modules property
                    self.modules += modules
                    
                }
                
          
            }catch {
                //couldnt parse
               // print(error)
            }
        }
        //kick off the task
        dataTask.resume()
        
    }
    
    func beginModule(_ moduleid: String) {
        //find the index for this module id
        for index in 0..<modules.count {
            if modules[index].id == moduleid {
                //found the matching module
                currentModuleIndex = index
                break
            }
        }
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex: Int ) {
        //reset current question index for resume view
        currentQuestionIndex = 0
        
        
        //check that the lesson index is within rage of module lesson
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }
        
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeDescription = addStyle(currentLesson!.explanation)
        
    }
    
    func hasNextLesson() -> Bool {
        guard currentModule != nil else {
            return false
        }
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
    
    func nextLesson() {
        //advance the lesson index
        currentLessonIndex += 1
        
        //check that it is with in lesson properity
        if currentLessonIndex < currentModule!.content.lessons.count {
            //set the current lesson proprity
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeDescription = addStyle(currentLesson!.explanation)
        } else {
            //default
            currentLessonIndex = 0
            currentLesson = nil
        }
        saveData()
    }
    
    func beginTest(_ moduleId: String) {
        //set current module
        beginModule(moduleId)
        //set curent question
        currentQuestionIndex = 0
        
        //reset lesson index
        currentLessonIndex = 0
        //if have question in test
        if currentModule?.test.questions.count ?? 0 > 0  {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            //set the content of question
            codeDescription = addStyle(currentQuestion!.content)
        }
    }
    
    func nextQuestion() {
        //advance the index question
        currentQuestionIndex += 1
        // check that still have next question
        if currentQuestionIndex < currentModule!.test.questions.count {
            //set the curent question propertity
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeDescription = addStyle(currentQuestion!.content)
        }else {
            //set defaut
            currentQuestionIndex = 0
            currentQuestion = nil
        }
        
        saveData()
    }
    
    private func addStyle(_ htmlString: String) -> NSAttributedString {
        var resultString = NSAttributedString()
        var data = Data()
        
        //add the styling data
        if styleData != nil {
            data.append(styleData!)
        }
        // append the html data
        data.append(Data(htmlString.utf8))
        
        //convert to attributted string
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            resultString = attributedString
        }
        return resultString
    }
}
