//
//  ViewController.m
//  UITestMonkey
//
//  Created by AZXX on 17/5/8.
//  Copyright © 2017年 AZXX. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) CGPoint movePoint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)drawPointAtPosition:(CGPoint)position withColor:(UIColor *)color {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, 5.0)];
    view.layer.masksToBounds = true;
    view.layer.cornerRadius = view.frame.size.height / 2.0;
    view.backgroundColor = color;
    view.center = CGPointMake(position.x, position.y);
    [self.view addSubview:view];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self drawPointAtPosition:point withColor:[UIColor redColor]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self drawPointAtPosition:point withColor:[UIColor greenColor]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self drawPointAtPosition:point withColor:[UIColor blueColor]];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
