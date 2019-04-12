//
//  UIEscortProfileDataTableViewController.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 11/04/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RealmSwift

class UIEscortProfileDataTableViewController: UITableViewController {
    
    var tabTitle = ""
    var dataKind = ""
    
    var userDataArray: Results<ProfileModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "UIEscortProfileDataTableViewCell", for: indexPath) as! UIEscortProfileDataTableViewCell
        
        cell.titleLabel?.text = "\(userDataArray?[indexPath.row].name.uppercased() ?? "")"
        cell.valueLabel?.text = userDataArray?[indexPath.row].value ?? ""
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }

}

extension UIEscortProfileDataTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: tabTitle)
    }

}

extension UIEscortProfileDataTableViewController: UserProfileChildViewControllerDelegate {
    func reloadData() {
        do {
            let realm = try Realm()
            userDataArray = realm.objects(ProfileModel.self).filter("kind_name ==[c] '\(dataKind)'")
        }catch{}
        
        tableView.reloadData()
    }
    
}
