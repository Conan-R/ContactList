//
//  ContactModel.swift
//  ContactListDemo
//
//  Created by iOS on 2020/4/29.
//  Copyright © 2020 beiduofen. All rights reserved.
//

import UIKit

class ContactModel: NSObject {
    var avatarSmallURL : String?   //头像小图
    var nameSpell : String? //中文名称
    var name : String?   //中文名称拼音
    var phone : String?
    var userId : String?
    
    @objc func compareContact(_ contactModel: ContactModel) -> ComparisonResult{
        let result = nameSpell!.compare(contactModel.nameSpell!)
        return result
    }
}
