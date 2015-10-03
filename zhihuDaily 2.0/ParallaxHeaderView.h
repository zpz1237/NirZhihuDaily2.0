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

+ (id)parallaxHeaderViewWithSubView:(UIView *)subView forSize:(CGSize)headerSize;
- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset;
@end
