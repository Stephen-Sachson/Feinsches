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
@synthesize attString;
@synthesize frames;
@synthesize images;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"%@",NSStringFromSelector(_cmd));
    }
    return self;
}

-(void)setAttString:(NSAttributedString *)string withImages:(NSArray*)imgs
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    self.attString = string;
    self.images = imgs;
    
    CTTextAlignment alignment = kCTJustifiedTextAlignment;
    
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    NSDictionary *attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (__bridge id)paragraphStyle, (NSString*)kCTParagraphStyleAttributeName,
                                    nil];
    
    NSMutableAttributedString* stringCopy = [[NSMutableAttributedString alloc] initWithAttributedString:self.attString];
    [stringCopy addAttributes:attrDictionary range:NSMakeRange(0, [attString length])];
    self.attString = (NSAttributedString*)stringCopy;
}

- (void)buildFrames
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    frameXOffset = 20; //1
    frameYOffset = 20;
    self.pagingEnabled = YES;
    self.delegate = self;
    self.frames = [NSMutableArray array];
    
    CGMutablePathRef path = CGPathCreateMutable(); //2
    CGRect textFrame = CGRectInset(self.bounds, frameXOffset, frameYOffset);
    CGPathAddRect(path, NULL, textFrame );
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    
    int textPos = 0; //3
    int columnIndex = 0;
    
    while (textPos < [attString length]) { //4
        CGPoint colOffset = CGPointMake( (columnIndex+1)*frameXOffset + columnIndex*(textFrame.size.width/2), 20 );
        CGRect colRect = CGRectMake(0, 0 , textFrame.size.width/2-10, textFrame.size.height-40);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, colRect);
        
        //use the column path
        //CFRangeMake(textPos, 0)  Zero tells the compiler to continue add lines until
        //frame setter hit the bottom or runs out of text which ever is sooner.
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame); //5
        
        //create an empty column view
        CTColumnView* content = [[CTColumnView alloc] initWithFrame: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
        content.backgroundColor = [UIColor clearColor];
        content.frame = CGRectMake(colOffset.x, colOffset.y, colRect.size.width, colRect.size.height) ;
        
		//set the column view contents and add it as subview
        
        [self attachImagesWithFrame:frame inColumnView: content];//Added l8r
        
        [content setCTFrame:(__bridge id)frame];  //6
        [self.frames addObject: (__bridge id)frame];
        [self addSubview: content];
        
        //prepare for next frame
        textPos += frameRange.length;
        
        //CFRelease(frame);
        CFRelease(path);
        
        columnIndex++;
    }
    
    //set the total width of the scroll view
    int totalPages = (columnIndex+1) / 2; //7
    self.contentSize = CGSizeMake(totalPages*self.bounds.size.width, textFrame.size.height);
}

-(void)attachImagesWithFrame:(CTFrameRef)f inColumnView:(CTColumnView*)col
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    //drawing images
    NSArray *lines = (NSArray *)CTFrameGetLines(f); //1
    
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(f, CFRangeMake(0, 0), origins); //2
    
    int imgIndex = 0; //3
    NSDictionary* nextImage = [self.images objectAtIndex:imgIndex];
    int imgLocation = [[nextImage objectForKey:@"location"] intValue];
    
    //find images for the current column
    CFRange frameRange = CTFrameGetVisibleStringRange(f); //4
    while ( imgLocation < frameRange.location ) {
        imgIndex++;
        if (imgIndex>=[self.images count]) return; //quit if no images for this column
        nextImage = [self.images objectAtIndex:imgIndex];
        imgLocation = [[nextImage objectForKey:@"location"] intValue];
    }
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) { //5
        CTLineRef line = (__bridge CTLineRef)lineObj;
        
        for (id runObj in (NSArray *)CTLineGetGlyphRuns(line)) { //6
            CTRunRef run = (__bridge CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);
            
            if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) { //7
	            CGRect runBounds;
	            CGFloat ascent;//height above the baseline
	            CGFloat descent;//height below the baseline
	            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
	            runBounds.size.height = ascent + descent;
                
	            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
	            runBounds.origin.x = origins[lineIndex].x + self.frame.origin.x + xOffset + frameXOffset;
	            runBounds.origin.y = origins[lineIndex].y + self.frame.origin.y + frameYOffset;
	            runBounds.origin.y -= descent;
                
                UIImage *img = [UIImage imageNamed: [nextImage objectForKey:@"fileName"] ];
                CGPathRef pathRef = CTFrameGetPath(f); //10
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                
                CGRect imgBounds = CGRectOffset(runBounds, colRect.origin.x - frameXOffset - self.contentOffset.x, colRect.origin.y - frameYOffset - self.frame.origin.y);
                [col.images addObject: //11
                 [NSArray arrayWithObjects:img, NSStringFromCGRect(imgBounds) , nil]
                 ];
                //load the next image //12
                imgIndex++;
                if (imgIndex < [self.images count]) {
                    nextImage = [self.images objectAtIndex: imgIndex];
                    imgLocation = [[nextImage objectForKey: @"location"] intValue];
                }
                
            }
        }
        lineIndex++;
    }
}

@end
