//
//  FFNumberedTextView.m
//
//  Created by Wesley Yang on 16/7/28.
//

#import "FFNumberedTextView.h"

#define TXT_VIEW_INSETS 8.0 // The default insets for a UITextView is 8.0 on all sides
#define NUM_TEXT_GAP   4.0
@interface FFNumberedTextView ()<UITextViewDelegate>

@end

@implementation FFNumberedTextView
{
    UITextView *_internalTextView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}

-(void)setupView
{
    [self setContentMode:UIViewContentModeRedraw];

    _internalTextView = [[UITextView alloc] init];
    _internalTextView.delegate = self;
    [self addSubview:_internalTextView];
    self.backgroundColor = [UIColor whiteColor];
    self.numBgColor = [UIColor colorWithWhite:0 alpha:0.12];
    self.numColor = [UIColor grayColor];
    self.maxNumSupported = 4;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [_internalTextView setBackgroundColor:backgroundColor];
}

-(UITextView *)innerTextView
{
    return _internalTextView;
}

-(void)setText:(NSString *)text
{
    _internalTextView.text = text;
}

-(NSString *)text
{
    return _internalTextView.text;
}

-(void)setEditable:(BOOL)editable
{
    _internalTextView.editable = editable;
}

-(BOOL)editable
{
    return _internalTextView.editable;
}

-(void)setNumBgColor:(UIColor *)numBgColor
{
    _numBgColor = numBgColor;
    [self setNeedsDisplay];
}

-(void)setNumColor:(UIColor *)numColor
{
    _numColor = numColor;
    [self setNeedsDisplay];
}

-(CGFloat)numViewWidth
{
    int maxNum = self.maxNumSupported;
    if (_internalTextView.font) {
        float wid8 = [@"8" sizeWithAttributes:@{NSFontAttributeName:_internalTextView.font}].width;
        return maxNum*wid8 + NUM_TEXT_GAP*2;
    }
    return 30;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat numViewW = self.numViewWidth;
    _internalTextView.frame = CGRectMake(numViewW, 0, CGRectGetWidth(self.frame) - numViewW, CGRectGetHeight(self.frame));
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    
    CGFloat numViewW = self.numViewWidth;

    //draw num bg
    CGContextSetFillColorWithColor(ctx, self.numBgColor.CGColor);
    CGRect numBgArea = CGRectMake(0, 0, numViewW, self.frame.size.height);
    CGContextFillRect(ctx, numBgArea);
    
    //draw line
//    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
//    CGContextMoveToPoint(ctx, 0, 0);
//    CGContextAddLineToPoint(ctx, 0, self.frame.size.height);
//    CGContextMoveToPoint(ctx, numViewW, 0);
//    CGContextAddLineToPoint(ctx, numViewW, self.frame.size.height);
//    CGContextStrokePath(ctx);
    
    [[_internalTextView textColor] set];
    CGFloat xOrigin, yOrigin, width/*, height*/;
    CGFloat lineH = _internalTextView.font.lineHeight;
    int numberOfLines= 0;
    if(lineH>0) numberOfLines= (_internalTextView.contentSize.height-2*TXT_VIEW_INSETS) / lineH;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentRight;
    
    for (int x = 0; x < numberOfLines; ++x) {
        NSString *lineNum = [NSString stringWithFormat:@"%d", x];
        
        xOrigin = CGRectGetMinX(self.bounds);
        
        yOrigin = (lineH * x) + TXT_VIEW_INSETS - _internalTextView.contentOffset.y;
        if (yOrigin<-lineH || yOrigin>self.frame.size.height+lineH) {
            continue;
        }
        
        width = [lineNum sizeWithAttributes:@{NSFontAttributeName:_internalTextView.font}].width;
        
        [lineNum drawInRect:CGRectMake(xOrigin, yOrigin, numViewW-NUM_TEXT_GAP, lineH) withAttributes:@{NSFontAttributeName:_internalTextView.font,NSParagraphStyleAttributeName:paraStyle,NSForegroundColorAttributeName:self.numColor}];
        
    }
    
    
    
    UIGraphicsPopContext();
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self setNeedsDisplay];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setNeedsDisplay];
}

@end
