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

    override func viewDidLoad() {
        super.viewDidLoad()

        getNews()
    }
    
    private func getNews() {
        print("okay, I try get news!")
        let getParameters = ["filters" : "post,photo", "max_photos" : "2", "count":"20"]
        if let getNews = VKRequest(method: "newsfeed.get", parameters: getParameters) {
            getNews.execute(resultBlock: { (_ response) in
                if let response = response {
                    self.prepareData(from: String(describing: response.json))
                }
            }, errorBlock: { (_ error) in
                print("VK error: \(String(describing: error))")
            })
        } else {
            print("can not get news request")
        }
    }
    
    private func prepareData(from jsonString: String) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
        } else {
            print("Ouh..I can not get the data :c")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
