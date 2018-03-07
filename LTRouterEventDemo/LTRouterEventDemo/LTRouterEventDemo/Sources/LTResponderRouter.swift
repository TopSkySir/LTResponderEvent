//
//  LTResponderRouter.swift
//  LTRouterEventDemo
//
//  Created by TopSky on 2018/3/5.
//  Copyright © 2018年 TopSky. All rights reserved.
//

import Foundation
import UIKit

// MARK: -  Router Event

extension UIResponder {

    public typealias RouterDecorateClosure = ([AnyHashable: Any]?) -> [AnyHashable: Any]?
    fileprivate typealias RouterTuple = (selector: Selector?, shouldNext: Bool, closure:  RouterDecorateClosure?)

    /**
     Register the routing table event.
     The added routing event will be set to the default routing event.
     */
    @objc public func registerRouterEvent() {

    }

    /**
     Post router event
     */
    public func post(routerEvent name: AnyHashable, _ userInfo: [AnyHashable: Any]? = nil) {

        checkInitTable()

        guard let event = initRouterTable?[name] as? RouterTuple else {
            next?.post(routerEvent: name, userInfo)
            return
        }

        var resultInfo = userInfo
        if let closure = event.closure {
            resultInfo = closure(resultInfo)
        }

        if let selector = event.selector, canPerformAction(selector, withSender: nil) {
            perform(selector, with: resultInfo)
        }

        if event.shouldNext {
            next?.post(routerEvent: name, resultInfo)
        }
    }

    /**
     Add router event
     */
    public func add(routerEvent name: AnyHashable, _ selector: Selector?, _ shouldNext: Bool = false, _ closure: RouterDecorateClosure? = nil) {
        checkTable()
        var routerTable = initRouterTable ?? [AnyHashable: Any]()
        routerTable[name] = (selector, shouldNext, closure)
        setInitRouterTable(routerTable)
    }

    /**
     Remove router event
     */
    public func remove(routerEvent name: AnyHashable) {
        checkTable()
        guard var routerTable = initRouterTable  else {
            return
        }
        routerTable[name] = nil
        setInitRouterTable(routerTable)
    }

    /**
     Replace router event
     */
    public func replace(routerEvent old: AnyHashable, routerEvent new: AnyHashable) {
        checkTable()
        guard var routerTable = initRouterTable  else {
            return
        }
        routerTable[old] = routerTable[new]
        setInitRouterTable(routerTable)
    }

    /**
     Exchange router event
     */
    public func exchange(routerEvent lhs: AnyHashable, routerEvent rhs: AnyHashable) {
        checkTable()
        guard var routerTable = initRouterTable  else {
            return
        }
        let temp = routerTable[lhs]
        routerTable[lhs] = routerTable[rhs]
        routerTable[rhs] = temp
        setInitRouterTable(routerTable)
    }

    /**
     Reset router event
     */
    public func resetRouterEvent() {
        setInitRouterTable(copyRouterTable)
    }

}


// MARK: - Router Check
extension UIResponder {

    fileprivate func checkTable() {
        checkInitTable()
        checkCopyTable()
    }

    fileprivate func checkInitTable() {
        guard shouldInit == nil else {
            return
        }
        setShouldInit(true)
        registerRouterEvent()
        setShouldInit(false)
    }

    fileprivate func checkCopyTable() {
        guard shouldInit != true else {
            return
        }
        guard shouldCopy else {
            return
        }
        doCopy()
        setShouldCopy(false)
    }

    fileprivate func doCopy() {
        setCopyRouterTable(initRouterTable)
    }

}


// MARK: - Router Storage
extension UIResponder {

    /**
     AssociatedObject Key
     */
    fileprivate struct LTResponderRouterKeys {
        static var shouldInit: String = "shouldInit"
        static var shouldCopy: String = "shouldCopy"
        static var initRouterTable: String = "initRouterTable"
        static var copyRouterTable: String = "copyRouterTable"
    }

    /**
     Get associatedObject
     */
    fileprivate func get(_ associatedKey: UnsafeRawPointer) -> Any? {
        return objc_getAssociatedObject(self, associatedKey)
    }

    /**
     Set associatedObject
     */
    fileprivate func set(_ associatedKey: UnsafeRawPointer, value: Any?) {
        if value is Bool {
            objc_setAssociatedObject(self, associatedKey, value, .OBJC_ASSOCIATION_ASSIGN)
        } else {
            objc_setAssociatedObject(self, associatedKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /**
     Get initTable of router
     */
    fileprivate var initRouterTable: [AnyHashable: Any]? {
        return get(&LTResponderRouterKeys.initRouterTable) as? [AnyHashable: Any]
    }


    /**
     Set initTable of router
     */
    fileprivate func setInitRouterTable(_ newValue: [AnyHashable: Any]?) {
        set(&LTResponderRouterKeys.initRouterTable, value: newValue)
    }

    /**
     Get shouldInit
     */
    fileprivate var shouldInit: Bool?{
        return get(&LTResponderRouterKeys.shouldInit) as? Bool
    }

    /**
     Set shouldInit
     */
    fileprivate func setShouldInit(_ newValue: Bool?) {
        set(&LTResponderRouterKeys.shouldInit, value: newValue)
    }


    /**
     Get shouldCopy
     */
    fileprivate var shouldCopy: Bool {
        return (get(&LTResponderRouterKeys.shouldCopy) as? Bool) ?? true
    }

    /**
     Set shouldCopy
     */
    fileprivate func setShouldCopy(_ newValue: Bool?) {
        set(&LTResponderRouterKeys.shouldCopy, value: newValue)
    }

    /**
     Get copyTable of router
     */
    fileprivate var copyRouterTable: [AnyHashable: Any]? {
        return get(&LTResponderRouterKeys.copyRouterTable) as? [AnyHashable: Any]
    }

    /**
     Set copyTable of router
     */
    fileprivate func setCopyRouterTable(_ newValue: [AnyHashable: Any]?) {
        set(&LTResponderRouterKeys.copyRouterTable, value: newValue)
    }
}
