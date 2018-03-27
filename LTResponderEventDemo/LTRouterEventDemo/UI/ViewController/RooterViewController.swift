//
//  RooterViewController.swift
//  LTRouterEventDemo
//
//  Created by TopSky on 2018/3/27.
//  Copyright © 2018年 TopSky. All rights reserved.
//

import UIKit

class RooterViewController: BaseTableViewController {

    override func add() {
        addPushViewcontroller(vcType: ContentViewController.self, title: "test")
    }

}
