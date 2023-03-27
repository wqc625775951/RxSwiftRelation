//
//  TableViewSample.swift
//  RxSwiftProject
//
//  Created by dhzy on 2023/2/14.
//
// 1111
import Foundation
import UIKit

class TableViewSample: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem.title = "列表"
        self.tabBarItem.image = UIImage(systemName: "paintbrush.pointed")
        self.tabBarItem.selectedImage = UIImage(systemName: "paintbrush.pointed.fill")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
}
