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
import CoreData

class NewsTableViewController: UITableViewController {
    
    private var groups = [Int : Group]()
    private var news = [News]()
    private var profiles = [Int : Profile]()
    
    let newsCellIndentifier = "newsCell"
    let aboutNewsSegueIdentifier = "aboutNewsSegue"
    
    let countRow = 20
    let maxPhotos = 2
    var loadMoreStatus = false
    var nextFrom: String?
    
    var footerView: LoadMoreView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavBar()
        prepareTableView()
        prepareRefrechControl()
        checkSession()
        restoreNewsVK()
        registerCell()
        getNewsVK(append: false) { (success) in
            DispatchQueue.main.async {
                if (success) {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - prepare methods
    
    private func prepareNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 80/255.0, green: 128/255.0, blue: 184/255.0, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    private func prepareTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 350
        tableView.tableFooterView?.isHidden = true
        footerView = LoadMoreView.instanceFromNib()
        tableView.tableFooterView = footerView
    }
    
    private func prepareRefrechControl() {
        let refreshingBegan = "Идет обновление..."
        refreshControl = UIRefreshControl()
        
        if let refreshControl = refreshControl {
            refreshControl.attributedTitle = NSAttributedString(string: refreshingBegan)
            refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        }
    }
    
    @objc private func refresh(sender: AnyObject) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.getNewsVK(append: false, loadEnd: { (success) in
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            })
        }
    }

    private func loadMore() {
        if (!loadMoreStatus) {
            loadMoreStatus = true
            footerView.loadMoreIndicator.startAnimating()
            tableView.tableFooterView?.isHidden = false
            DispatchQueue.global(qos: .userInitiated).async {
                self.getNewsVK(append: true, loadEnd: { (success) in
                    self.tableView.reloadData()
                    self.loadMoreStatus = false
                    self.footerView.loadMoreIndicator.stopAnimating()
                    self.tableView.tableFooterView?.isHidden = true
                })
            }
        }
    }
    
    private func registerCell() {
        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: newsCellIndentifier)
    }
    
    private func checkSession() {
        VKSdk.wakeUpSession(scope) { (state, error) in
            if state == .initialized {
                self.logOut()
            }
        }
    }
    
    //MARK: - works with news
    
    private func restoreNewsVK() {
        news = CoreDataStore.getNews()
        groups = CoreDataStore.getGroups()
        profiles = CoreDataStore.getProfiles()
    }
    
    private func getNewsVK(append: Bool, loadEnd: @escaping (Bool) -> ()) {
        var getParameters: [String : Any] = ["filters" : "post", "max_photos" : "\(maxPhotos)", "count":"\(countRow)"]
        if (append) {
            if let startFrom = nextFrom {
                getParameters["start_from"] = startFrom
            }
        }
        
        if let request = VKRequest(method: "newsfeed.get", parameters: getParameters) {
            request.execute(resultBlock: { (response) in
                if let jsonResponse = response {
                    print(jsonResponse.json)
                    let json = JSON(jsonResponse.json)
                    self.prepareData(with: json, append: append)
                    loadEnd(true)
                }
            }, errorBlock: { (error) in
                loadEnd(false)
                print("error")
            })
        }
        
    }
    
    private func prepareData(with json: JSON, append: Bool) {
        if (!append) {
            CoreDataStore.deleteAllData(entity: CoreDataStore.newsManagedName)
            CoreDataStore.deleteAllData(entity: CoreDataStore.sourceManagedName)
            news.removeAll()
            profiles.removeAll()
            groups.removeAll()
        }
        
        let itemsJSON = json["items"].arrayValue
        
        for itemJSON in itemsJSON {
            var imagesURL = [URL]()
            
            let typeString = itemJSON["post_type"].stringValue
            let type = (typeString == "post") ? NewsType.post : NewsType.copy
            let sourceID = itemJSON["source_id"].intValue
            let dateUnixTime = itemJSON["date"].intValue
            let date = Date(timeIntervalSince1970: TimeInterval(dateUnixTime))
            let text = itemJSON["text"].stringValue
            let postID = itemJSON["post_id"].int32Value
            
            let attachments = itemJSON["attachments"].arrayValue
            for attachment in attachments {
                if attachment["type"].stringValue == "photo" {
                    let imageUrlJSON = attachment["photo"]["photo_604"].stringValue
                    if let imageURL = URL(string: imageUrlJSON) {
                        imagesURL.append(imageURL)
                    }
                }
            }
            
            let newsStruct = News(type: type, sourceID: sourceID, date: date, text: text, imagesURL: imagesURL, postID: postID)
            news.append(newsStruct)
            CoreDataStore.save(news: newsStruct)
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
            CoreDataStore.save(source: profile, with: profileID)
            
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
            groups[-groupID] = group
            CoreDataStore.save(source: group, with: -groupID)
            
            print("--------------------------------")
            print("groupID: \(groupID)")
            print(group)
        }
        
        nextFrom = json["next_from"].stringValue
    }
    
    //MARK: - user methods
    
    @IBAction func onExitClick(_ sender: UIBarButtonItem) {
        let cancel = "Отмена"
        let exit = "Выход"
        
        let confirmAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        let exitAction = UIAlertAction(title: exit, style: .destructive) { (action) in
            self.logOut()
        }
        confirmAlert.addAction(cancelAction)
        confirmAlert.addAction(exitAction)
        
        present(confirmAlert, animated: true, completion: nil)
    }
        
    private func logOut() {
        if let storyboard = self.storyboard {
            VKSdk.forceLogout()
            UserDefaults.standard.set(false, forKey: authorizedKey)
            
            let loginController = storyboard.instantiateViewController(withIdentifier: loginControllerIdentifier)
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
            return groups[sourceID]
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
            if let image = CoreDataStore.getPhoto(from: sourceNewsID) {
                cell.avatarImageView.image = image
            } else {
                cell.avatarImageView.kf.setImage(with: source.photoURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                    if let image = image {
                        CoreDataStore.save(sourceID: sourceNewsID, image: image)
                    }
                })
            }
        }
        if let savedImages = CoreDataStore.getPostPhotos(from: news.postID) {
            for (i, image) in savedImages.enumerated() {
                if i == maxPhotos { break }
                cell.photoImageViews[i].isHidden = false
                cell.photoImageViews[i].image = image
                cell.photoImageViews[i].backgroundColor = UIColor.white
            }
        } else {
            for (i, imageURL) in news.imagesURL.enumerated() {
                if i == maxPhotos { break }
                cell.photoImageViews[i].isHidden = false
                cell.photoImageViews[i].kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, casheType, url) in
                    if let image = image {
                        CoreDataStore.save(postID: news.postID, image: image)
                    }
                })
                cell.photoImageViews[i].backgroundColor = UIColor.white
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == news.count - 1 {
            loadMore()
        }
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
