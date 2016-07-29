//
//  FFNumberedTextView.h
//
//  Created by Wesley Yang on 16/7/28.
//

#import <UIKit/UIKit.h>

@interface FFNumberedTextView : UIView

@property (nonatomic,strong) NSString *text;
@property (nonatomic,assign) BOOL editable;

/**
 *  数字区域背景
 */
@property (nonatomic,strong) UIColor *numBgColor;
/**
 *  数字颜色
 */
@property (nonatomic,strong) UIColor *numColor;

/**
 *  最大位数支持
 */
@property (nonatomic,assign) CGFloat maxNumSupported;

/**
 *  内部textView
 */
@property (nonatomic,readonly) UITextView *innerTextView;

@end
