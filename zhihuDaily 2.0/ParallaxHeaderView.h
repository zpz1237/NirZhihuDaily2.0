//
//  ParallaxHeaderView.h
//  ParallaxTableViewHeader
//
//  Created by Vinodh  on 26/10/14.
//  Copyright (c) 2014 Daston~Rhadnojnainva. All rights reserved.

//

#import <UIKit/UIKit.h>

@class ParallaxHeaderView;

@protocol ParallaxHeaderViewDelegate <NSObject>

- (void)lockDirection;

@end

@interface ParallaxHeaderView : UIView

@property (nonatomic, weak) UILabel *headerTitleLabel;
@property (nonatomic, weak) id<ParallaxHeaderViewDelegate> delegate;
@property (nonatomic, weak) UIImage *blurViewImage;

+ (id)parallaxHeaderViewWithSubView:(UIView *)subView forSize:(CGSize)headerSize;
+ (id)parallaxWebHeaderViewWithSubView:(UIView *)subView forSize:(CGSize)headerSize;
+ (id)parallaxThemeHeaderViewWithSubView:(UIView *)subView forSize:(CGSize)headerSize andImage: (UIImage *)blurViewImageParam;
- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset;
- (void)layoutWebHeaderViewForScrollViewOffset:(CGPoint)offset;
- (void)layoutThemeHeaderViewForScrollViewOffset:(CGPoint)offset;
- (void)refreshBlurViewForNewImage;
@end
