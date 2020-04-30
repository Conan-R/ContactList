//
//  ContactListController.swift
//  ContactListDemo
//
//  Created by iOS on 2020/4/28.
//  Copyright © 2020 beiduofen. All rights reserved.
//

import UIKit

class ContactListController: UIViewController {

    private var sortedKeys = [String]()
    private var dataDict: Dictionary<String, NSMutableArray>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        fetchDataList()
        // Do any additional setup after loading the view.
    }
    
    private func fetchDataList() {
        guard let path = Bundle.main.path(forResource: "contact", ofType: "json") else { return }
        do {
            let tempList = NSMutableArray()
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .dataReadingMapped)
            if let dict: NSDictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? NSDictionary  {
                if let dataArray: NSArray = dict["data"] as? NSArray {
                    for dict in dataArray {
                        if let noneDict = dict as? [String: String] {
                            let model = ContactModel()
                            model.avatarSmallURL = noneDict["avatar_url"]
                            model.name = noneDict["name"]
                            model.nameSpell = noneDict["name_spell"]
                            model.phone = noneDict["phone"]
                            model.userId = noneDict["userId"]
                            tempList.add(model)
                        }
                    }
                    tempList.sortedArray(using: #selector(ContactModel.compareContact(_:)))
                }
            }
            
            var dataSource: Dictionary = Dictionary<String, NSMutableArray>()
            for model in tempList {
                let contact = model as! ContactModel
                guard let nameSpell = contact.nameSpell else { continue }
                let firstLetter = String(nameSpell.first!)
                if let letterArray: NSMutableArray = dataSource[firstLetter] {
                    letterArray.add(model)
                } else {
                    let tempArray = NSMutableArray()
                    tempArray.add(contact)
                    dataSource[firstLetter] = tempArray
                }
            }
            
            sortedKeys = Array(dataSource.keys).sorted(by: <)
            dataDict = dataSource
            
            tableView.reloadData()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        table.delegate = self
        table.dataSource = self
        return table
    }()
}

extension ContactListController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key: String = sortedKeys[section]
        let dataArray: NSMutableArray = dataDict![key]!
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        let key: String = sortedKeys[indexPath.section]
        let dataArray: NSMutableArray = dataDict![key]!
        if let data: ContactModel = dataArray[indexPath.row] as? ContactModel {
            cell.textLabel?.text = data.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard let _ =  dataDict else {
            return []
        }
        return sortedKeys as [String]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedKeys[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
}
