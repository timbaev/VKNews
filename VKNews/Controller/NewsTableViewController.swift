//
//  NewsTableViewController.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 30.09.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit
import VKSdkFramework
import SwiftyJSON

class NewsTableViewController: UITableViewController {
    
    private var groups = [Int : Group]()
    private var news = [News]()
    private var profiles = [Int : Profile]()
    
    let newsCellIndentifier = "newsCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 350

        registerCell()
        getNewsVK()
    }
    
    private func registerCell() {
        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: newsCellIndentifier)
    }
    
    private func getNewsVK() {
        let getParameters: [String : Any]? = ["filters" : "post", "max_photos" : "2", "count":"20"]
        if let request = VKRequest(method: "newsfeed.get", parameters: getParameters) {
            request.execute(resultBlock: { (response) in
                if let jsonResponse = response {
                    print(jsonResponse.json)
                    let json = JSON(jsonResponse.json)
                    self.prepareData(with: json)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }, errorBlock: { (error) in
                print("error")
            })
        }
        
    }
    
    private func prepareData(with json: JSON) {
        let itemsJSON = json["items"].arrayValue
        
        for itemJSON in itemsJSON {
            var imagesURL = [String]()
            
            let typeString = itemJSON["post_type"].stringValue
            let type = (typeString == "post") ? NewsType.post : NewsType.copy
            let sourceID = itemJSON["source_id"].intValue
            let dateUnixTime = itemJSON["date"].intValue
            let date = Date(timeIntervalSince1970: TimeInterval(dateUnixTime))
            let text = itemJSON["text"].stringValue
            
            let attachments = itemJSON["attachments"].arrayValue
            for attachment in attachments {
                if attachment["type"].stringValue == "photo" {
                    let imageUrlJSON = attachment["photo"]["photo_604"].stringValue
                    imagesURL.append(imageUrlJSON)
                }
            }
            
            news.append(News(type: type, sourceID: sourceID, date: date, text: text, imagesURL: imagesURL))
        }
        
        news.forEach { print("--------------------------------"); print($0) }
        
        let profilesJSON = json["profiles"].arrayValue
        for profileJSON in profilesJSON {
            let profileID = profileJSON["id"].intValue
            let profileName = profileJSON["first_name"].stringValue
            let profileSurname = profileJSON["last_name"].stringValue
            let photoURL = profileJSON["photo_100"].stringValue
            
            let profile = Profile(name: profileName, surname: profileSurname, photoURL: photoURL)
            profiles[profileID] = profile
            
            print("--------------------------------")
            print("profileID: \(profileID)")
            print(profile)
        }
        
        let groupsJSON = json["groups"].arrayValue
        for groupJSON in groupsJSON {
            let groupID = groupJSON["id"].intValue
            let groupName = groupJSON["name"].stringValue
            let photoURL = groupJSON["photo_100"].stringValue
            
            let group = Group(name: groupName, photoURL: photoURL)
            groups[groupID] = group
            
            print("--------------------------------")
            print("groupID: \(groupID)")
            print(group)
        }
    }
    
    
    
    @IBAction func onExitClick(_ sender: UIBarButtonItem) {
        if let storyboard = self.storyboard {
            VKSdk.forceLogout()
            
            let loginController = storyboard.instantiateViewController(withIdentifier: "loginViewController")
            self.present(loginController, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellIndentifier, for: indexPath) as! NewsTableViewCell
        
        let news = self.news[indexPath.row]
        let sourceNewsID = news.sourceID
        var source: Source!
        if sourceNewsID > 0 {
            source = profiles[sourceNewsID]!
            cell.prepareCell(with: news, with: source)
        } else {
            source = groups[abs(sourceNewsID)]!
            cell.prepareCell(with: news, with: source)
        }
        
        cell.avatarImageView.image = nil
        cell.photoImageViews[0].image = nil
        cell.photoImageViews[1].image = nil
        cell.avatarImageView.downloadImageFrom(link: source.photoURL, contentMode: .scaleAspectFit)
        
        cell.photoImageViews[0].isHidden = true
        cell.photoImageViews[1].isHidden = true
        
        for (i, imageURL) in news.imagesURL.enumerated() {
            if i == 2 { break }
            cell.photoImageViews[i].isHidden = false
            cell.photoImageViews[i].downloadImageFrom(link: imageURL, contentMode: .scaleAspectFit)
            cell.photoImageViews[i].backgroundColor = UIColor.white
        }
        
        return cell
    }

}
