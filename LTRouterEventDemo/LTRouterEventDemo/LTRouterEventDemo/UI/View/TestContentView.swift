//
//  TestContentView.swift
//  LTRouterEventDemo
//
//  Created by TopSky on 2018/3/5.
//  Copyright © 2018年 TopSky. All rights reserved.
//

import UIKit

class TestContentView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    static let ShareKey: String = "shareKey"
    static let OrderKey: Int = 1

    let button = UIButton()
    let button2 = UIButton()


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.green
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(onClick(target:)), for: .touchUpInside)
        button.setTitle("1", for: .normal)
        addSubview(button)

        button2.frame = CGRect(x: 150, y: 0, width: 100, height: 100)
        button2.backgroundColor = UIColor.red
        button2.addTarget(self, action: #selector(onClick2(target:)), for: .touchUpInside)
        button2.setTitle("2", for: .normal)
        addSubview(button2)

    }

    deinit {
        print("TestContentView deinit")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc fileprivate func onClick(target: Any) {
        post(routerEvent: TestContentView.ShareKey)
        post(routerEvent: TestContentView.ShareKey, ["action": "Share"])
    }

    @objc fileprivate func onClick2(target: Any) {
        post(routerEvent: TestContentView.OrderKey, ["action": "Order"])
    }

}
