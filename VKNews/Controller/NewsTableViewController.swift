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
    let aboutNewsSegueIdentifier = "aboutNewsSegue"

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
            var imagesURL = [URL]()
            
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
                    if let imageURL = URL(string: imageUrlJSON) {
                        imagesURL.append(imageURL)
                    }
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
            let photoUrlString = profileJSON["photo_100"].stringValue
            guard let photoURL = URL(string: photoUrlString) else { continue }
            
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
            let photoUrlString = groupJSON["photo_100"].stringValue
            guard let photoURL = URL(string: photoUrlString) else { continue }
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == aboutNewsSegueIdentifier {
            let row = sender as! Int
            let targetNews = news[row]
            if let source = getSourceNews(from: targetNews.sourceID) {
                let aboutNewsController = segue.destination as! AboutNewsViewController
                aboutNewsController.news = targetNews
                aboutNewsController.source = source
            }
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
    
    private func getSourceNews(from sourceID: Int) -> Source? {
        if sourceID > 0 {
            return profiles[sourceID]
        } else {
            return groups[abs(sourceID)]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellIndentifier, for: indexPath) as! NewsTableViewCell
        
        let news = self.news[indexPath.row]
        let sourceNewsID = news.sourceID
        if let source = getSourceNews(from: sourceNewsID) {
            cell.prepareCell(with: news, with: source)
            cell.avatarImageView.image = nil
            cell.photoImageViews[0].setDefault()
            cell.photoImageViews[1].setDefault()
            cell.avatarImageView.kf.setImage(with: source.photoURL)
        }
        
        for (i, imageURL) in news.imagesURL.enumerated() {
            if i == 2 { break }
            cell.photoImageViews[i].isHidden = false
            cell.photoImageViews[i].kf.setImage(with: imageURL)
            cell.photoImageViews[i].backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: aboutNewsSegueIdentifier, sender: indexPath.row)
    }
}

fileprivate extension UIImageView {
    
    func setDefault() {
        self.image = nil
        self.backgroundColor = .darkGray
        self.isHidden = true
    }
    
}
