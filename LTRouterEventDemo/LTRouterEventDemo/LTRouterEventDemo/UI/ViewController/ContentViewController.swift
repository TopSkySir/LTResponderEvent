//
//  ContentViewController.swift
//  LTRouterEventDemo
//
//  Created by TopSky on 2018/3/5.
//  Copyright © 2018年 TopSky. All rights reserved.
//

import UIKit

class ContentViewController: BaseContentViewController {

    let testView = TestContentView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentView.addSubview(testView)
        testView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        self.title = "Router Event"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func add() {

        addAction(title: "add decorator by viewControler") { [weak self] in
            self?.add(routerEvent: TestContentView.ShareKey, #selector(self?.getEvent(_:)), false, { (userInfo) -> [AnyHashable : Any]? in
                var result = userInfo
                if result?["isContent"] != nil {
                    result?["action"] = "add content decorator"
                } else {
                    result?["action"] = "add decorator"
                }
                return result
            })
        }

        addAction(title: "add decorator by contentView ") { [weak self] in
            self?.contentView.add(routerEvent: TestContentView.ShareKey, #selector(self?.getEvent(_:)), true, { (userInfo) -> [AnyHashable : Any]? in
                var result = userInfo
                result?["action"] = "content decorator"
                result?["isContent"] = true
                return result
            })
        }

        addAction(title: "remove action1") { [weak self] in
            self?.remove(routerEvent: TestContentView.ShareKey)
        }


        addAction(title: "replace action1 with action2") { [weak self] in
            self?.replace(routerEvent: TestContentView.ShareKey, routerEvent: TestContentView.OrderKey)

        }

        addAction(title: "exchange action1 and action2") { [weak self] in
            self?.exchange(routerEvent: TestContentView.ShareKey, routerEvent: TestContentView.OrderKey)
        }

        addAction(title: "reset") { [weak self] in
            self?.contentView.remove(routerEvent: TestContentView.ShareKey)
            self?.resetRouterEvent()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    deinit {
        print("ContentViewController deinit")
    }
}

extension ContentViewController {

    override func registerRouterEvent() {
        add(routerEvent: TestContentView.ShareKey, #selector(getEvent(_:)))
        add(routerEvent: TestContentView.OrderKey, #selector(getEvent2(_:)))
    }

    @objc func getEvent(_ userInfo: [AnyHashable: Any]?) {
        let title = "action is nil"
        self.title = "getEvent1: \((userInfo?["action"] as? String) ?? title)"
    }

    @objc func getEvent2(_ userInfo: [AnyHashable: Any]?) {
       self.title = userInfo?["action"] as? String
    }

}

