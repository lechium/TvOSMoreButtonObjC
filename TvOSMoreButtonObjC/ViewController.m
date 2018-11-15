//
//  ViewController.m
//  TvOSMoreButtonObjC
//
//  Created by Kevin Bradley on 11/12/18.
//  Copyright © 2018 Kevin Bradley. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.testButton.text = @"It is the year 1985. Marty McFly, a mild-mannered high school student, stopped by Dr. Emmett L. Brown's laboratory to play around with an amplifier. Then he receives a message from Doc that he needs help from him for Doc's latest invention, a time machine made out of a DeLorean sports car that can travel through time instantaneously when it reaches a speed velocity of 88 MPH. \nThen, Doc was gunned down by Libyan Nationalists, Marty makes an effort to escape from the Lybians by using the time machine. Then Marty accidentally warps himself into 1955. Where he meets both of his parents when they were teenagers, then Marty unintentionally interrupts his parent's first meeting together, he then finds a younger version of Doc and together they try to find a way to get Marty's parents-to-be back together, and to get Marty back to 1985.";
    //self.testButton.textAlignment = NSTextAlignmentJustified;
    
    //self.testButton.text = @"Just a bunch of words";
    self.testButton.buttonWasPressed = ^(NSString *text) {
      
        NSLog(@"full text: %@", text);
        
    };
    self.testButton.trailingTextFont = [UIFont boldSystemFontOfSize:8];
    //self.testButton.ellipsesString = @"……";
    //self.testButton.textColor = [UIColor whiteColor];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
