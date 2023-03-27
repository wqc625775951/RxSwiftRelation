//
//  MainTableView.swift
//  RxSwiftProject
//
//  Created by dhzy on 2023/2/15.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit

// MARK: StuctData
struct DataModel {
    // .Type 是类型，类型的 .self 是元类型的值。比如我们说 5 是 Int 类型，此时 5 是 Int 类型的一个值。
    let className: UIViewController.Type?
    let name: String?
}

// wwww
struct DataListModel {
    let data = Observable.just([
        DataModel(className: SignUpPage.self,name: "登陆"),
        DataModel(className: ImageSelect.self,name: "图片展示"),
        DataModel(className: UILabelInterval.self, name: "UILabe计数器"),
        DataModel(className: UITextFieldFun.self, name: "TestField本文编辑框"),
        DataModel(className: ButtonSample.self, name: "按钮相关"),
        DataModel(className: SegmentUISample.self, name: "segment相关"),
        DataModel(className: TwoBindAndGesture.self, name: "双向绑定与手势"),
        DataModel(className: DatePickerUISample.self, name: "时间选择器")
    ])
}

func setButtonStyle(button: UIButton, title: String, fontSize: CGFloat, color:UIColor = .blue) {
    button.layer.cornerRadius = 10
    button.backgroundColor = .lightGray
    button.setTitle(title, for: .normal)
    button.isSelected = false
    button.setTitleColor(color, for: .normal)
    button.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: fontSize)
}

class MainTableView: UIViewController {
    lazy var tableView = UITableView()
    let dataList = DataListModel()
    var disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem.title = "列表"
        self.tabBarItem.image = UIImage(systemName: "paintbrush.pointed")
        self.tabBarItem.selectedImage = UIImage(systemName: "paintbrush.pointed.fill")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: life
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: initUI
    func setUI() {
        self.navigationItem.title = "列表数据"
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        dataList.data
            .bind(to: tableView.rx.items(cellIdentifier:"myCell")) { _, model, cell in
                cell.textLabel?.text = model.name
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(DataModel.self).subscribe({ event in
            let lVCClass = event.element?.className
            if let lVCClass = lVCClass {
                let lVC = lVCClass.init()
                self.navigationController?.pushViewController(lVC, animated: true)
            }	
        }).disposed(by: disposeBag)
    }
    
    // MARK: private
    
    // MARK: public
}
