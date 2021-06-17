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
    
    //Curent lesson explanation
    @Published var lessonDescription = NSAttributedString()
    
    //current lesson/ question index
    @Published var currentContentSelected:Int?
    var styleData: Data?
    
   // var styleData: Data?
    
    init() {
        getLocalData()
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
        lessonDescription = addStyle(currentLesson!.explanation)
        
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
            lessonDescription = addStyle(currentLesson!.explanation)
        } else {
            //default
            currentLessonIndex = 0
            currentLesson = nil
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
