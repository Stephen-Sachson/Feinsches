//
//  ViewController.m
//  Feinsches
//
//  Created by Mafia on 4/22/14.
//  Copyright (c) 2014 Stephen Sachson. All rights reserved.
//

#import "ViewController.h"
#import "CTView.h"
#import "MarkupParser.h"

@interface ViewController ()

@end

@implementation ViewController
static int i=0;
static BOOL increase;
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",NSStringFromSelector(_cmd));
	// Do any additional setup after loading the view, typically from a nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"zombies" ofType:@"txt"];
    NSString* text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    MarkupParser* p = [[MarkupParser alloc] init];
    NSAttributedString* attString = [p attrStringFromMarkup: text];
    [self.documentView setAttString:attString withImages:p.images];
    [self.documentView buildFrames];
    
    increase=YES;
    [self gradient];
}

- (void)gradient {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    int p;
    if (increase) {
        p=i++;
    }
    else {
        p=i--;
    }
    
    if ((increase && i>2000) || (!increase && i<0)) {
        increase=!increase;
    }
    
    float hey=(float)p/2000;
    self.view.backgroundColor=[UIColor colorWithRed:hey green:1-hey blue:0 alpha:1];
//    NSLog(@"%@ %.3f",NSStringFromSelector(_cmd),hey);
    [self performSelector:_cmd withObject:nil afterDelay:0.01f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
