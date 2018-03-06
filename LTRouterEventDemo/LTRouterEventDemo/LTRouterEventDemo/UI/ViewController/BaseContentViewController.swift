//
//  BaseContentViewController.swift
//  LTExtensionDemo
//
//  Created by TopSky on 2018/2/27.
//  Copyright © 2018年 TopSky. All rights reserved.
//

import UIKit

class BaseContentViewController: BaseTableViewController {

    let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let height = view.frame.height/2
        contentView.backgroundColor = UIColor.white
        contentView.frame = CGRect(x: 0, y: height, width: view.frame.width, height: height)
        view.addSubview(contentView)

        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
