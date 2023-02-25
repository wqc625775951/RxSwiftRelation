//
//  RxSwiftStudyOne.swift
//  RxSwiftProject
//
//  Created by dhzy on 2023/2/13.
//

import Foundation
import UIKit

class RxSwiftStudyOne: UIView {
    lazy var usernameTitle = UILabel()
    lazy var usernameTexfiled = UITextField()
    lazy var usernameAlert = UILabel()
    
    lazy var passwordTitle = UILabel()
    lazy var passwordTexfiled = UITextField()
    lazy var passwordAlert = UILabel()
    
    lazy var commitButton = UIButton()
    
    let minimalPasswordLength = 5
    let minimalUsernameLength = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: init UI
    func initUI() {
        
        self.addSubview(self.usernameTitle)
        self.usernameTitle.attributedText = self.setRichText(str: "Username")
        self.usernameTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaInsets.bottom).offset(180)
            make.left.equalTo(self).offset(40)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        
        self.addSubview(self.usernameTexfiled)
        usernameTexfiled.borderStyle = UITextField.BorderStyle.roundedRect
        self.usernameTexfiled.snp.makeConstraints { (make) in
            make.top.equalTo(self.usernameTitle.snp_bottomMargin).offset(20)
            make.left.equalTo(self.usernameTitle)
            make.right.equalTo(self).offset(-30)
            make.height.equalTo(self.usernameTitle)
            
        }
        
        self.addSubview(self.usernameAlert)
        usernameAlert.text = "Username has to be at least \(minimalUsernameLength) characters"
        self.usernameAlert.snp.makeConstraints { (make) in
            make.top.equalTo(self.usernameTexfiled.snp_bottomMargin).offset(15)
            make.left.equalTo(self.usernameTitle)
            make.height.equalTo(self.usernameTitle)
            make.right.equalTo(self.usernameTexfiled)
        }
        
        self.addSubview(self.passwordTitle)
        self.passwordTitle.attributedText = self.setRichText(str: "Password")
        self.passwordTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.usernameAlert).offset(80)
            make.left.right.equalTo(self.usernameAlert)
            make.height.equalTo(self.usernameTitle)
        }
        
        self.addSubview(self.passwordTexfiled)
        passwordTexfiled.borderStyle = UITextField.BorderStyle.roundedRect
        self.passwordTexfiled.snp.makeConstraints { (make) in
            make.top.equalTo(self.passwordTitle.snp_bottomMargin).offset(20)
            make.left.equalTo(self.usernameTitle)
            make.height.equalTo(self.usernameTitle)
            make.right.equalTo(self).offset(-30)
        }
        
        self.addSubview(self.passwordAlert)
        passwordAlert.text = "Password has to be at least \(minimalPasswordLength) characters"
        self.passwordAlert.snp.makeConstraints { (make) in
            make.top.equalTo(self.passwordTexfiled.snp_bottomMargin).offset(15)
            make.left.equalTo(self.usernameTexfiled)
            make.height.equalTo(self.usernameTexfiled)
            make.right.equalTo(self.usernameTexfiled)
        }
        
        self.commitButton = UIButton.init(type: .system)
        self.addSubview(self.commitButton)
        self.commitButton.backgroundColor = .lightGray
        self.commitButton.setTitle("commit", for: .normal)
        self.commitButton.titleLabel?.textColor = UIColor.black
        self.commitButton.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 30)
        self.commitButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.passwordAlert.snp_bottomMargin).offset(30)
            make.left.equalTo(self.usernameTexfiled)
            make.height.equalTo(50)
            make.right.equalTo(self.usernameTexfiled)
        }
        
    }
    
    // MARK: helper
    func setRichText(str: String) -> NSMutableAttributedString {
        let mutableString = NSMutableAttributedString(string: str)
        mutableString.addAttributes(
        [.font: UIFont.systemFont(ofSize: 20, weight: .medium), .foregroundColor: UIColor.red],
            range: NSRange(location: 0, length: 3)
        )
        mutableString.addAttributes(
        [.font: UIFont.systemFont(ofSize: 20, weight: .medium), .foregroundColor: UIColor.black],
            range: NSRange(location: 3, length: 2)
        )
        mutableString.addAttributes(
            [.font: UIFont.systemFont(ofSize: 20, weight: .medium), .foregroundColor: UIColor.blue],
            range: NSRange(location: 5, length: 3)
        )
        return mutableString
    }
    
}
