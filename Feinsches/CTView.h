//
//  CTView.h
//  Feinsches
//
//  Created by Mafia on 4/26/14.
//  Copyright (c) 2014 Stephen Sachson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "CTColumnView.h"

@interface CTView : UIScrollView <UIScrollViewDelegate> {
    float frameXOffset;
    float frameYOffset;
    
    NSAttributedString* attString;
    
    NSMutableArray *frames;
}
@property (nonatomic, strong) NSAttributedString* attString;
@property (nonatomic, strong) NSMutableArray *frames;

- (void)buildFrames;
@end
