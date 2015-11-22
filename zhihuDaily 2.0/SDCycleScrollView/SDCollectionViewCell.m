//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


/**
 
 *******************************************************
 *                                                      *
 * 感谢您的支持， 如果下载的代码在使用过程中出现BUG或者其他问题    *
 * 您可以发邮件到gsdios@126.com 或者 到                       *
 * https://github.com/gsdios?tab=repositories 提交问题     *
 *                                                      *
 *******************************************************
 
 */

#import "GradientView.h"
#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"
#import "myUILabel.h"

@implementation SDCollectionViewCell
{
    __weak myUILabel *_titleLabel;
    __weak GradientView *_blurView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
    }
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    //Edit -- 改了图片缩放模式
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView = imageView;
    [self addSubview:imageView];
    
    GradientView *blurView = [[GradientView alloc] initWithFrame:self.bounds type:TRANSPARENT_GRADIENT_TWICE_TYPE];
    _blurView = blurView;
    [self addSubview: blurView];
}

- (void)setupTitleLabel
{
    myUILabel *titleLabel = [[myUILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    
    //为Label添加阴影及居下对齐及不剪切及分布
    titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    titleLabel.verticalAlignment = VerticalAlignmentBottom;
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:titleLabel];
    
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"%@", title];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _blurView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [[_blurView layer] sublayers][0].removeFromSuperlayer;
    _blurView.insertTwiceTransparentGradient;
    
    //使titleLabel不被遮挡
    [self bringSubviewToFront:_titleLabel];
    
    //根据offset不断调整的Alpha
    _titleLabel.alpha = self.titleLabelAlpha;
    
    _imageView.frame = self.bounds;
    
    CGFloat titleLabelW = self.sd_width;
    CGFloat titleLabelH = _titleLabelHeight;
    CGFloat titleLabelX = 15;
    CGFloat titleLabelY = self.sd_height - titleLabelH - 25;
    _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW - 2*titleLabelX, titleLabelH);
    _titleLabel.hidden = !_titleLabel.text;
}

@end
