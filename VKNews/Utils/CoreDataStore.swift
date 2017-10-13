//
//  CoreDataSaver.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 13.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit
import CoreData

fileprivate enum SourceType {
    case profile
    case group
}

class CoreDataStore {
    
    //MARK: - get methods
    
    static func getNews() -> [News] {
        var news = [News]()
        let managedContext = CoreDataManager.instance.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NewsManaged")
        
        do {
            let newsManageds = try managedContext.fetch(fetchRequest) as! [NewsManaged]
            for newsManaged in newsManageds {
                let newsType:NewsType = (newsManaged.type) ? .post : .copy
                let sourceID:Int = Int(newsManaged.sourceID)
                let date:Date = newsManaged.date! as Date
                let text:String = newsManaged.text!
                let imageLinks = newsManaged.imageLinks
                var imagesURL = [URL]()
                imageLinks.forEach({ (link) in
                    if let url = URL(string: link) {
                        imagesURL.append(url)
                    }
                })
                
                news.append(News(type: newsType, sourceID: sourceID, date: date, text: text, imagesURL: imagesURL))
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return news
    }
    
    static func getProfiles() -> [Int : Profile] {
        return getSources(with: .profile) as! [Int : Profile]
    }
    
    static func getGroups() -> [Int : Group] {
        return getSources(with: .group) as! [Int : Group]
    }
    
    private static func getSources(with type: SourceType) -> [Int : Source] {
        var sources = [Int : Source]()
        let managedContext = CoreDataManager.instance.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SourceManaged")
        let filter = "0"
        var predicate: NSPredicate!
        if type == .profile {
            predicate = NSPredicate(format: "sourceID > %@", filter)
        } else if type == .group {
            predicate = NSPredicate(format: "sourceID < %@", filter)
        }
        fetchRequest.predicate = predicate
        
        do {
            let sourceManageds = try managedContext.fetch(fetchRequest) as! [SourceManaged]
            for sourceManaged in sourceManageds {
                let sourceID:Int = Int(sourceManaged.sourceID)
                let fullName:String = sourceManaged.name
                let photoLink = sourceManaged.avatar
                guard let url = URL(string: photoLink) else { continue }
                if type == .profile {
                    let splitedName = fullName.components(separatedBy: " ")
                    let name = splitedName[0]
                    let surname = splitedName[1]
                    sources[sourceID] = Profile(name: name, surname: surname, photoURL: url)
                } else if type == .group {
                    sources[sourceID] = Group(name: fullName, photoURL: url)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return sources
    }
    
    private static func getSource(from sourceID: Int) -> SourceManaged? {
        let managedContext = CoreDataManager.instance.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SourceManaged")
        let filter = String(sourceID)
        let predicate = NSPredicate(format: "sourceID == %@", filter)
        fetchRequest.predicate = predicate
        
        do {
            let sourceManageds = try managedContext.fetch(fetchRequest) as! [SourceManaged]
            guard sourceManageds.count == 1 else { print("not found source"); return nil }
            return sourceManageds[0]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    static func getPhoto(from sourceID: Int) -> UIImage? {
        if let sourceManaged = getSource(from: sourceID) {
            if let imageData = sourceManaged.avatarImageData {
                if let image = UIImage(data: imageData) {
                    return image
                }
            }
        }
        return nil
    }
    
    //MARK: - save methods
    
    static func save(news: News) {
        let managedContext = CoreDataManager.instance.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "NewsManaged", in: managedContext)!
        let newsManaged = NewsManaged(entity: entity, insertInto: managedContext)
        
        let typeBool = (news.type == .post)
        var imageLinks = [String]()
        news.imagesURL.forEach { imageLinks.append($0.absoluteString) }
        
        newsManaged.type = typeBool
        newsManaged.sourceID = Int32(news.sourceID)
        newsManaged.date = news.date as NSDate
        newsManaged.text = news.text
        newsManaged.imageLinks = imageLinks
        
        CoreDataManager.instance.saveContext()
    }
    
    static func save(source: Source, with id: Int) {
        let managedContext = CoreDataManager.instance.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "SourceManaged", in: managedContext)!
        let sourceManaged = SourceManaged(entity: entity, insertInto: managedContext)
        
        var name = source.name
        if let profile = source as? Profile {
            name = "\(profile.name) \(profile.surname)"
        }
        
        sourceManaged.name = name
        sourceManaged.avatar = source.photoURL.absoluteString
        sourceManaged.sourceID = Int32(id)
        
        CoreDataManager.instance.saveContext()
    }
    
    static func save(sourceID: Int, image: UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 1)
        
        if let sourceManaged = getSource(from: sourceID) {
            sourceManaged.avatarImageData = imageData
            CoreDataManager.instance.saveContext()
        }
    }
    
    //MARK: - delete methods
    
    static func deleteAllData(entity: String) {
        let managedContext = CoreDataManager.instance.managedObjectContext
        let delAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: entity))
        do {
            try managedContext.execute(delAllReqVar)
        } catch {
            print(error)
        }
    }
}
