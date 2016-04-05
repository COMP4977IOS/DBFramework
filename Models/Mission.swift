//
//  Mission.swift
//  ArcticRun-iPad
//
//  Created by Jacky Lui on 2016-04-05.
//  Copyright © 2016 COMP 4977. All rights reserved.
//

import Foundation
import CloudKit

public class Mission{
    static let publicDB:CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    public
    
    var record:CKRecord?
    
    init(missionRecord:CKRecord){
        self.record = missionRecord
    }
    
    init(audioSegment:Int, crew:CKReference, progress:Int, title:String){
        self.record = CKRecord(recordType: "Mission")
        
        self.record?.setObject(audioSegment, forKey: "audioSegment")
        self.record?.setObject(crew, forKey: "crew")
        self.record?.setObject(progress, forKey: "progress")
        self.record?.setObject(title, forKey: "title")
    }
    
    func getAudioSegment() -> Int? {
        return self.record?.objectForKey("audioSegment") as? Int
    }
    
    func setAudioSegment(audioSegment:Int) -> Void {
        self.record?.setObject(audioSegment, forKey: "audioSegment")
    }
    
    func getCrew() -> CKReference? {
        return self.record?.objectForKey("crew") as? CKReference
    }
    
    func setCrew(crew:CKReference) -> Void {
        self.record?.setObject(crew, forKey: "crew")
    }
    
    func getProgress() -> Int? {
        return self.record?.objectForKey("progress") as? Int
    }
    
    func setProgress(progress:Int) -> Void {
        self.record?.setObject(progress, forKey: "progress")
    }
    
    func getTitle() -> String? {
        return self.record?.objectForKey("title") as? String
    }
    
    func setTitle(title:String) -> Void {
        self.record?.setObject(title, forKey: "title")
    }
    
    static func getMission(userRecord: CKRecord, onComplete:([Mission]) -> Void) -> Void{
        let predicate:NSPredicate = NSPredicate(format: "user == %@", userRecord)
        let query:CKQuery = CKQuery(recordType: "Mission", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]   //sort by desc
        
        //perform query
        publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error: NSError?) -> Void in
            if(error != nil || records == nil){
                return  //nothing
            }
            
            var missions:[Mission] = []
            for var i = 0; i < records?.count; i++ {
                let mission:Mission = Mission(missionRecord: records![i])
                missions.append(mission)
            }
            
            onComplete(missions)
        }
    }
    
    static func getAllMissions(onComplete:([Mission]) -> Void) -> Void{
        let predicate:NSPredicate = NSPredicate(value: true)
        let query:CKQuery = CKQuery(recordType: "Mission", predicate: predicate)
        
        publicDB.performQuery(query, inZoneWithID: nil) { (records: [CKRecord]?, error:NSError?) -> Void in
            if error != nil || records == nil {
                return //found errors
            }
            
            var missions:[Mission] = []
            for var i = 0; i < records?.count; i++ {
                let mission:Mission = Mission(missionRecord: records![i])
                missions.append(mission)
            }
            
            onComplete(missions)
        }
    }

    
}