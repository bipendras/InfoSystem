//
//  configurationFile.swift
//  nBulletin
//
//  Created by beependra on 2/16/17.
//  Copyright © 2017 Leading Professional Technology. All rights reserved.
//

import Foundation

//class configurationFile{
public let appname:String = "Awareness International Academy"
    public let baseurl:String = "http://demo.nbulletin.com"
public let datadef = UserDefaults.standard


public let api_key:String = "a1"
    public var noticeurl:String = "\(baseurl)/api/v1/notice?api_key=\(api_key)"
    public var newsurl:String = "\(baseurl)/api/v1/news?api_key=\(api_key)"
    public var fileurl:String = "\(baseurl)/api/v1/file?api_key=\(api_key)"
    public var resourceurl:String = "\(baseurl)/api/v1/resource?api_key=\(api_key)"
    public var galleryurl:String = "\(baseurl)/api/v1/gallery?api_key=\(api_key)"
    public var albumurl:String = "\(baseurl)/api/v1/gallery/"
    public var contacturl:String = "\(baseurl)/api/v1/contact?api_key=\(api_key)"
    public var eventurl:String = "\(baseurl)/api/v1/event?api_key=\(api_key)"
    public var abouturl:String = "\(baseurl)/api/v1/about?api_key=\(api_key)"
public var fcmurl:String = "\(baseurl)/api/v1/token?api_key=\(api_key)&d=ios"

    public var pmessageurl:String = "\(baseurl)/api/v1/student/messages?api_token="
    public var gmessageurl:String = "\(baseurl)/api/v1/student/messages/group?api_token="
    public var leaveRequesturl:String = "\(baseurl)/api/v1/student/leave?api_token="

    public var loginurl:String = "\(baseurl)/api/v1/student/login?api_key=\(api_key)"

    public let appphone:String = "01-4782629"
    public let appaddress:String = "Sankhamul"
    public let appwebsite:String = "http://aiaschool.edu.np"

    public var primaryColor:UIColor = UIColor(colorLiteralRed: 39/255, green: 82/255, blue: 141/255, alpha: 1.0)

