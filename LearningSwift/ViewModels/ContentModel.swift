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
    
    var styleData: Data?
    
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
    
}
