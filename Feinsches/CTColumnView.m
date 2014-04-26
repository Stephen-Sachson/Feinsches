//
//  CTColumnView.m
//  Feinsches
//
//  Created by Mafia on 4/26/14.
//  Copyright (c) 2014 Stephen Sachson. All rights reserved.
//

#import "CTColumnView.h"

@implementation CTColumnView
@synthesize images;

-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]!=nil) {
        self.images = [NSMutableArray array];
    }
    return self;
}

-(void)setCTFrame: (id) f
{
    ctFrame = f;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw((CTFrameRef)ctFrame, context);
    
    for (NSArray* imageData in self.images) {
        UIImage* img = [imageData objectAtIndex:0];
        CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
        CGContextDrawImage(context, imgBounds, img.CGImage);
    }
}
@end
