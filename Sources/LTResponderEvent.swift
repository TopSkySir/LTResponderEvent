//
//  LTResponderEvent.swift
//  LTeventDemo
//
//  Created by TopSky on 2018/3/5.
//  Copyright © 2018年 TopSky. All rights reserved.
//

import Foundation
import UIKit

// MARK: -  UIResponder Event

extension UIResponder{

    /**
     Register the routing table event.
     The added routing event will be set to the default routing event.
     */
    @objc open func registerResponderEvent() {

    }
}

public extension UIResponder {

    typealias EventDecorateClosure = ([AnyHashable: Any]?) -> [AnyHashable: Any]?
    fileprivate typealias EventTuple = (selector: Selector?, shouldNext: Bool, closure:  EventDecorateClosure?)


    /**
     Post UIResponder event
     */
    func post(event name: AnyHashable, _ userInfo: [AnyHashable: Any]? = nil) {

        checkInitTable()

        guard let event = initEventTable?[name] as? EventTuple else {
            next?.post(event: name, userInfo)
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
            next?.post(event: name, resultInfo)
        }
    }

    /**
     Add UIResponder event
     */
    func add(event name: AnyHashable, _ selector: Selector?, _ shouldNext: Bool = false, _ closure: EventDecorateClosure? = nil) {
        checkTable()
        var eventTable = initEventTable ?? [AnyHashable: Any]()
        eventTable[name] = (selector, shouldNext, closure)
        setInitEventTable(eventTable)
    }

    /**
     Remove UIResponder event
     */
    func remove(event name: AnyHashable) {
        checkTable()
        guard var eventTable = initEventTable  else {
            return
        }
        eventTable[name] = nil
        setInitEventTable(eventTable)
    }

    /**
     Replace UIResponder event
     */
    func replace(event old: AnyHashable, event new: AnyHashable) {
        checkTable()
        guard var eventTable = initEventTable  else {
            return
        }
        eventTable[old] = eventTable[new]
        setInitEventTable(eventTable)
    }

    /**
     Exchange UIResponder event
     */
    func exchange(event lhs: AnyHashable, event rhs: AnyHashable) {
        checkTable()
        guard var eventTable = initEventTable  else {
            return
        }
        let temp = eventTable[lhs]
        eventTable[lhs] = eventTable[rhs]
        eventTable[rhs] = temp
        setInitEventTable(eventTable)
    }

    /**
     Reset UIResponder event
     */
    func resetResponderEvent() {
        setInitEventTable(copyEventTable)
    }

}


// MARK: - UIResponder Check

fileprivate extension UIResponder {

    func checkTable() {
        checkInitTable()
        checkCopyTable()
    }

    func checkInitTable() {
        guard shouldInit == nil else {
            return
        }
        setShouldInit(true)
        registerResponderEvent()
        setShouldInit(false)
    }

    func checkCopyTable() {
        guard shouldInit != true else {
            return
        }
        guard shouldCopy else {
            return
        }
        doCopy()
        setShouldCopy(false)
    }

    func doCopy() {
        setCopyEventTable(initEventTable)
    }

}


// MARK: - Event Storage

fileprivate extension UIResponder {

    /**
     AssociatedObject Key
     */
    struct LTResponderEventKeys {
        static var shouldInit: String = "LTResponderEvent.shouldInit"
        static var shouldCopy: String = "LTResponderEvent.shouldCopy"
        static var initEventTable: String = "LTResponderEvent.initEventTable"
        static var copyEventTable: String = "LTResponderEvent.copyEventTable"
    }

    /**
     Get associatedObject
     */
    func get(_ associatedKey: UnsafeRawPointer) -> Any? {
        return objc_getAssociatedObject(self, associatedKey)
    }

    /**
     Set associatedObject
     */
    func set(_ associatedKey: UnsafeRawPointer, value: Any?) {
        if value is Bool {
            objc_setAssociatedObject(self, associatedKey, value, .OBJC_ASSOCIATION_ASSIGN)
        } else {
            objc_setAssociatedObject(self, associatedKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /**
     Get initTable
     */
    var initEventTable: [AnyHashable: Any]? {
        return get(&LTResponderEventKeys.initEventTable) as? [AnyHashable: Any]
    }


    /**
     Set initTable
     */
    func setInitEventTable(_ newValue: [AnyHashable: Any]?) {
        set(&LTResponderEventKeys.initEventTable, value: newValue)
    }

    /**
     Get shouldInit
     */
    var shouldInit: Bool?{
        return get(&LTResponderEventKeys.shouldInit) as? Bool
    }

    /**
     Set shouldInit
     */
    func setShouldInit(_ newValue: Bool?) {
        set(&LTResponderEventKeys.shouldInit, value: newValue)
    }


    /**
     Get shouldCopy
     */
    var shouldCopy: Bool {
        return (get(&LTResponderEventKeys.shouldCopy) as? Bool) ?? true
    }

    /**
     Set shouldCopy
     */
    func setShouldCopy(_ newValue: Bool?) {
        set(&LTResponderEventKeys.shouldCopy, value: newValue)
    }

    /**
     Get copyTable
     */
    var copyEventTable: [AnyHashable: Any]? {
        return get(&LTResponderEventKeys.copyEventTable) as? [AnyHashable: Any]
    }

    /**
     Set copyTable
     */
    func setCopyEventTable(_ newValue: [AnyHashable: Any]?) {
        set(&LTResponderEventKeys.copyEventTable, value: newValue)
    }
}
