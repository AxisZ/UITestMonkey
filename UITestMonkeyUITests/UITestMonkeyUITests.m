//
//  UITestMonkeyUITests.m
//  UITestMonkeyUITests
//
//  Created by AZXX on 17/5/8.
//  Copyright © 2017年 AZXX. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface UITestMonkeyUITests : XCTestCase

@property (nonatomic, assign) unsigned int numberOfEvent;           // 手势操作次数
@property (nonatomic, assign) unsigned int delayBetweenEvents;      // 事件之间的间隔时间
@property (nonatomic, assign) unsigned int screenshotInterval;      // 截屏
@property (nonatomic, strong) NSDictionary *eventWeight;            // 手势和权重
@property (nonatomic, assign) unsigned int totalWeight;             // 权重之和

@end

@implementation UITestMonkeyUITests

- (void)setUp {
    [super setUp];
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
    _totalWeight = 0;
    for (NSString *key in _eventWeight) {
        _totalWeight += [[_eventWeight objectForKey:key] intValue];
    }
    
    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];
}

- (void)tearDown {
    [super tearDown];
}




//  获取0-1的随机数
- (CGFloat)getRandomValueBetween0And1 {
    return (CGFloat)((float)arc4random() / (float)UINT32_MAX);
}

//  ok
- (XCUICoordinate *)getCoordinateForVector:(CGVector)vector {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *window = [app.windows elementBoundByIndex:0];
    XCUICoordinate *coordinate = [window coordinateWithNormalizedOffset:vector];
    return coordinate;
}


- (XCUICoordinate *)getRandomCoordinate {
    CGFloat randomX = [self getRandomValueBetween0And1];
    CGFloat randomY = [self getRandomValueBetween0And1];
    CGVector randomVector = CGVectorMake(randomX, randomY);
    XCUICoordinate *coordinate = [self getCoordinateForVector:randomVector];
    return coordinate;
}


//  权重随机--计算出权重总和，取出一个随机数，遍历所有元素，把权重相加currentTotal，当currentTotal大于等于随机数字的时候停止，取出当前的元组
- (NSString *)getRandomEventName {
    int rad = arc4random() % _totalWeight + 1;  //  1到total的随机数
    int currentTotal = 0;
    NSString *eventName = [[NSString alloc] init];
    for (NSString *key in _eventWeight) {
        currentTotal += [[_eventWeight objectForKey:key] intValue];
        if (rad <= currentTotal) {
            eventName = key;
            break;
        }
    }
    return eventName;
}


- (void)scrollfromCoordinate:(XCUICoordinate *)fromCoordinate toCoordinate:(XCUICoordinate *)toCoordinate {
    if (fromCoordinate.screenPoint.y < [UIApplication sharedApplication].statusBarFrame.size.height) {
        printf("Do not open notifications center");
        return;
    }
    
    if (fromCoordinate.screenPoint.y > [[[XCUIApplication alloc] init].windows elementBoundByIndex:0].frame.size.height - 20.0) {
        printf("Do not open Control center");
        return;
    }
    
    [fromCoordinate pressForDuration:0 thenDragToCoordinate:toCoordinate];
}


- (void)executeRandomEvent {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    NSString *randomEventName = [self getRandomEventName];
    XCUICoordinate *coordinate = [self getRandomCoordinate];
    XCUIDevice *device = [XCUIDevice sharedDevice];
    CGSize maxSize = [app.windows elementBoundByIndex:0].frame.size;
    CGFloat startX = coordinate.screenPoint.x;
    CGFloat startY = coordinate.screenPoint.y;
    if ([randomEventName isEqualToString:@"tap"]) {
        [coordinate tap];
    }
    else if ([randomEventName isEqualToString:@"doubleTap"]) {
        [coordinate doubleTap];
    }
    else if ([randomEventName isEqualToString:@"scrollUp"]) {
        CGFloat dy = (startY * [self getRandomValueBetween0And1]) / maxSize.height;
        CGVector vector = CGVectorMake(coordinate.screenPoint.x / maxSize.width, dy);
        [self scrollfromCoordinate:coordinate toCoordinate:[self getCoordinateForVector:vector]];
    }
    else if ([randomEventName isEqualToString:@"scrollDown"]) {
        CGFloat dy = ((maxSize.height - startY) * [self getRandomValueBetween0And1] + startY) / maxSize.height;
        CGVector vector = CGVectorMake(coordinate.screenPoint.x / maxSize.width, dy);
        [self scrollfromCoordinate:coordinate toCoordinate:[self getCoordinateForVector:vector]];
    }
    else if ([randomEventName isEqualToString:@"scrollLeft"]) {
        CGFloat dx = startX * [self getRandomValueBetween0And1];
        CGVector vector = CGVectorMake(dx, coordinate.screenPoint.y / maxSize.height);
        [self scrollfromCoordinate:coordinate toCoordinate:[self getCoordinateForVector:vector]];
    }
    else if ([randomEventName isEqualToString:@"scrollRight"]) {
        CGFloat dx = ((maxSize.width - startX) * [self getRandomValueBetween0And1] + startX) / maxSize.width;
        CGVector vector = CGVectorMake(dx, coordinate.screenPoint.y / maxSize.height);
        [self scrollfromCoordinate:coordinate toCoordinate:[self getCoordinateForVector:vector]];
    }
    else if ([randomEventName isEqualToString:@"orientation"]) {
        // UIDeviceOrientation的enum有7种，typedef enum UIDeviceOrientation : NSInteger
        NSInteger random = arc4random() % 4 + 1;
        device.orientation = random;
        sleep(_delayBetweenEvents);
    }
    else if ([randomEventName isEqualToString:@"scroll"]) {
        [self scrollfromCoordinate:coordinate toCoordinate:[self getRandomCoordinate]];
    }
    else if ([randomEventName isEqualToString:@"press"]) {
        [coordinate pressForDuration:2];
    }
    else {
        NSLog(@"----------------->>getRandomEventName错误 或 isEqualToString:@xx, xx与_eventWeight不一致");
    }
    NSLog(@"----------------->>执行的手势是%@, coordinate是%@",randomEventName,coordinate);
    sleep(_delayBetweenEvents);
}

- (void)testReleaseTheMonkey {
    for (int i=0; i<_numberOfEvent; i++) {
        [self executeRandomEvent];
    }
}

@end
