UITestMonkey
==
UITestMonkey is a simple stress tool based on UITests and OC.
## How to use UITestMonkey?
1. Choose "show the test navigator"<br>
![show the test navigator](/docimg/test_navigator.png)
2. Choose "add a new test target or class", and choose "New UI Test Target..."(If you chose "Include UI Tests" when created your project, you don't have to do this step.)<br>
![show the test navigator](/docimg/test_target.png)
3. Now, copy the code(/UITestMonkeyUITests/UITestMonkeyUITests.m) in your own "new UI Test Target". Of course, you should change the "UITestMonkeyUITests" into your own product name.
## Key
- Weighted Random
- XCUICoordinate. [A location on screen relative to some UI element.](https://developer.apple.com/reference/xctest/xcuicoordinate?language=objc)
## configuration
You can change the following values.
```sh
    _numberOfEvent = 1000;
    _delayBetweenEvents = 1;
    _screenshotInterval = 5;    // 待用
    _eventWeight = @{@"tap"         :@"500",
                     @"doubleTap"   :@"100",
                     @"scrollUp"    :@"20",
                     @"scrollDown"  :@"20",
                     @"scrollLeft"  :@"10",
                     @"scrollRight" :@"10",
                     @"orientation" :@"1",
                     @"scroll"      :@"30",
                     @"press"       :@"50"};
```
_numberOfEvent, it's how many events will happen to your application.
_eventWeight, are relative weights to determine how often an event gets triggered. For example, the "tap" event is 500 and the "doubleTap" event is 100. A "tap" is 5 times more likely to occur than a "doubleTap".
