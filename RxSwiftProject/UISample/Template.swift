//
//  ViewController.swift
//  RxSwiftProject
//
//  Created by dhzy on 2023/2/13.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class Template: UIViewController {
    let disposeBag = DisposeBag()
    
    
    // MARK: life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUIView()
        self.setRxSwift()
    }
    
    // MARK: RxSwift
    func setRxSwift() {
        
    }
    
    // MARK: helper
    func setRichTextAttribute(value: NSInteger) -> Void {
    

    }
    
    // MARK: private
    
    func initUIView() {
        self.view.backgroundColor = .white
//        self.view.addSubview(self.labelTime)
    }
}

