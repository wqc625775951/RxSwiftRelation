//
//  CalculatePage.swift
//  RxSwiftProject
//
//  Created by dhzy on 2023/2/14.
//

import Foundation
import UIKit

class CalculatorPage: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem.title = "计算"
        self.tabBarItem.image = UIImage(systemName: "keyboard")
        self.tabBarItem.selectedImage = UIImage(systemName: "keyboard.fill")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    init() {
//          super.init(nibName: nil, bundle: nil)
//
//      }
//
//      public required init?(coder aDecoder: NSCoder) {
//          super.init(coder: aDecoder)
//      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
}
