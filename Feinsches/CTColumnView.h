//
//  CTColumnView.h
//  Feinsches
//
//  Created by Mafia on 4/26/14.
//  Copyright (c) 2014 Stephen Sachson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface CTColumnView : UIView {
    id ctFrame;
    
    NSMutableArray *images;
}
@property (nonatomic, strong) NSMutableArray *images;
-(void)setCTFrame:(id)f;
@end