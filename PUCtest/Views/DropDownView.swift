//
//  DropDownView.swift
//  PUCtest
//
//  Created by MAGNANIG-NB on 04/11/2018.
//  Copyright © 2018 MAGNANIG-NB. All rights reserved.
//

import UIKit
import GooglePlaces

class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var isGoogleMenu = false
    var dropDownGoogleOptions = [GMSAutocompletePrediction]()
    var dropDownOptions = [Sport]()
    var tableView = UITableView()
    var delegate : DropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isGoogleMenu {
            return dropDownGoogleOptions.count
        }
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if isGoogleMenu {
            cell.textLabel?.text = dropDownGoogleOptions[indexPath.row].attributedFullText.string
        } else {
            cell.textLabel?.text = dropDownOptions[indexPath.row].name
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isGoogleMenu {
            self.delegate.dropDown(pressed: dropDownGoogleOptions[indexPath.row])
        } else {
            self.delegate.dropDown(pressed: dropDownOptions[indexPath.row])
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


