//
//  ContentModel.swift
//  LearningSwift
//
//  Created by DHV on 14/06/2021.
//

import Foundation

class ContentModel: ObservableObject {
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
        //Parse local include json data
        getLocalData()
        
        //Parse remote json file and parse the data
        getRemoteData()
        
    }
    
    func getLocalData() {
        
        //get a url to json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            //read the file into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            //assign parsed modules to modules property
            self.modules = modules
            
        }catch {
            //print the error
            print(error)
        }
        
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
                
                //append parsed modules into modules property
                self.modules += modules
                
            }catch {
                //couldnt parse
               // print(error)
            }
        }
        //kick off the task
        dataTask.resume()
        
    }
    
    func beginModule(_ moduleid: Int) {
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
    }
    
    func beginTest(_ moduleId: Int) {
        //set current module
        beginModule(moduleId)
        //set curent question
        currentQuestionIndex = 0
        
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
