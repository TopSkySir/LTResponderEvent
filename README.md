# LTResponderEvent
-
Event manager based on event response chain

## Requirements
* Xcode 9+
* Swift 4.0+
* iOS 8+

## Installation
LTResponderEvent is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

	pod 'LTResponderEvent'

## Usage

### Post Event 
Define a name as key for event.
	
	static let ShareKey: String = "TestContentView.ShareKey"
   	static let OrderKey: Int = "TestContentView.OrderKey"
Post a event

 	post(event: TestContentView.ShareKey)
You can also post a event with somethings:
	
	post(event: TestContentView.ShareKey, ["action": "Share"])
 	

### Register Event
Add events you want to respond to. In this function, the new event will be accepted as the default.

	override func registerResponderEvent() {
        add(event: TestContentView.ShareKey, #selector(getEvent(_:)))
    }
    
    @objc func getEvent(_ userInfo: [AnyHashable: Any]?) {
        self.title = userInfo?["action"] as? String
    }

### Add 

You can add events easily.

	add(event: TestContentView.ShareKey, #selector(getEvent(_:)))
	
You can also influence the next responder by adding some decorations.
	
	add(event: TestContentView.ShareKey, #selector(getEvent(_:)), false) { (userInfo) -> [AnyHashable : Any]? in
            var result = userInfo
            result?["address"] = "BeiJing"
            return result
    }
### Remove 
Remove unwanted events.
	
	remove(event: TestContentView.ShareKey)

### Replace 
You can replace some events.
	
	replace(event: TestContentView.ShareKey, event: TestContentView.OrderKey)
	
### Exchange 
Exchange two events 
	
	exchange(event: TestContentView.ShareKey, event: TestContentView.OrderKey)
	
### Reset 
After the exchange or delete or addition, the default event can be restored.

	resetResponderEvent()
	
## License
LTResponderEvent is available under the MIT license. See the LICENSE file for more info.
	
