# LTRouterEvent
-
Event manager based on event response chain

## Requirements
* Xcode 9+
* Swift 4.0+
* iOS 8+

## Installation
LTRouterEvent is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

	pod 'LTRouterEvent'

## Usage

### Post Event 
Define a name as key for event.
	
	static let ShareKey: String = "shareKey"
   	static let OrderKey: Int = 1
Post a event

 	post(routerEvent: TestContentView.ShareKey)
You can also post a event with somethings:
	
	post(routerEvent: TestContentView.ShareKey, ["action": "Share"])
 	

### Register Event
Add events you want to respond to. In this function, the new event will be accepted as the default.

	override func registerRouterEvent() {
        add(routerEvent: TestContentView.ShareKey, #selector(getEvent(_:)))
    }
    
    @objc func getEvent(_ userInfo: [AnyHashable: Any]?) {
        self.title = userInfo?["action"] as? String
    }

### Add 

You can add events easily.

	add(routerEvent: TestContentView.ShareKey, #selector(getEvent(_:)))
	
You can also influence the next responder by adding some decorations.
	
	add(routerEvent: TestContentView.ShareKey, #selector(getEvent(_:)), false) { (userInfo) -> [AnyHashable : Any]? in
            var result = userInfo
            result?["address"] = "BeiJing"
            return result
    }
### Remove 
Remove unwanted events.
	
	remove(routerEvent: TestContentView.ShareKey)

### Replace 
You can replace some events.
	
	replace(routerEvent: TestContentView.ShareKey, routerEvent: TestContentView.OrderKey)
	
### Exchange 
Exchange two events 
	
	exchange(routerEvent: TestContentView.ShareKey, routerEvent: TestContentView.OrderKey)
	
### Reset 
After the exchange or delete or addition, the default event can be restored.

	resetRouterEvent()
	
## License
LTRouterEvent is available under the MIT license. See the LICENSE file for more info.
	
