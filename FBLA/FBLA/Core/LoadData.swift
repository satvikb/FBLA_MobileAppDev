//
//  LoadData.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import Foundation


class LoadData {
    
    static func readData() -> AllData {
        
        var topics : [Topic] = []
        var questionCount : Int = 0;
        
        let filePath = Bundle.main.resourcePath!

        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: filePath), includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let mp3Files = directoryContents.filter{ $0.pathExtension == "json" }
            print("mp3 urls:",mp3Files)
            let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
            print("mp3 list:", mp3FileNames)
            
            
            
            
            
            
            for path in mp3Files {
                do {
                    let data = try Data(contentsOf: path, options: .mappedIfSafe)
                    
                    if let json = try? JSONDecoder().decode(Topic.self, from: data){
                        
                        topics.append(json)
                        questionCount += json.questions.count
                    }
                } catch {
                    // handle error
                    print("no json \(error.localizedDescription)")
                }
            }
            
            
            
            
            
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        return AllData(topicTotalCount: topics.count, questionTotalCount: questionCount, topics: topics)
    }
}
