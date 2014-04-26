//
//  CTView.m
//  Feinsches
//
//  Created by Mafia on 4/26/14.
//  Copyright (c) 2014 Stephen Sachson. All rights reserved.
//

#import "CTView.h"
#import "MarkupParser.h"

@implementation CTView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity); //0
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable(); //1
    CGPathAddRect(path, NULL, self.bounds );
    
    MarkupParser *p=[[MarkupParser alloc] init];
    NSAttributedString* attString = [p attrStringFromMarkup:@"Text in black color <font color=\"red\">followed by red color text <font color=\"blue\">and then blue."]; //2
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString); //3
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [attString length]), path, NULL);
    
    CTFrameDraw(frame, context); //4
    
    CFRelease(frame); //5
    CFRelease(path);
    CFRelease(framesetter);
}


@end
